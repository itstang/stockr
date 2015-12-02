require 'twitter.rb'
require "#{Rails.root}/config/initializers/alchemyapi.rb"
require 'nokogiri'
require 'open-uri'

class StaticPagesController < ApplicationController

  def home
  end

  def help
  end

  def about
  end

  def dashboard
    y_client = YahooFinance::Client.new
    @user_owns = User_Owns.where(email: current_user.email)
    @data = y_client.quotes(@user_owns.pluck(:symbol), [:name, :day_value_change, :bid, :sentiment])


    @user_owns.each_with_index do |stock, index|
        @data[index].sentiment= sentiment(stock.symbol)
    end
  end

  def stocks
    @stocks = Stock.all
  end

  def stocks_show
    @stock = Stock.find(params[:id])
  end

  def stocks_add
    User_Owns.create(email: current_user.email, symbol: params[:symbol])
    redirect_to dashboard_url
  end

  def scrape_media(stock)
    links_arr = Array.new
    url = 'http://finance.yahoo.com/q?s='

    doc = Nokogiri::HTML(open(url+stock))
    scrape_list = doc.css('#yfi_headlines .bd ul li').children
    scrape_list.each do |link|
      if !link.attributes['href'].nil?
        links_arr.push(link.attributes['href'].value.gsub(/.*?(?=\*http)\*/, ""))
      end
    end
    puts links_arr.inspect
  end

  def sentiment(stock_symbol)
    alchemyapi = AlchemyAPI.new()
        num_tweets=0
        total_score=0
        avg_sentiment= 0
        new_tweets_arr = Array.new

        tweets = $twitter.search('$' + stock_symbol + ' -rt',
                                   result_type: 'mixed',
                                   count: 20).take(3)

        # remove url from tweets
        tweets.each do |tweet|
          tweet_no_url= tweet.text.dup
          tweet_no_url.gsub!(/(?:f|ht)tps?:\/[^\s]+/, '')
          new_tweets_arr.push(tweet_no_url)
        end

        # remove duplicates
        new_tweets_arr.uniq!
        new_tweets_arr.each do |tweet|
          tweet_sentiment= alchemyapi.sentiment("text", tweet)
          if tweet_sentiment["status"] == 'OK' && tweet_sentiment["docSentiment"]["score"] != nil
            total_score += tweet_sentiment["docSentiment"]["score"].to_f
            num_tweets= num_tweets + 1
          end
        end
        if(num_tweets == 0)
          avg_sentiment = 0
        else
          avg_sentiment = total_score/num_tweets
        end
        return avg_sentiment
  end

  def history
    @user ||= User.find(session[:email]) if session[:email]
  end

  def contact

  end

  helper_method :scrape_media
end
