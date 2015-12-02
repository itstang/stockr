require 'twitter.rb'
require "#{Rails.root}/config/initializers/alchemyapi.rb"

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
    yahoo_client = YahooFinance::Client.new
    yahoo_client = YahooFinance::Client.new
    @historical_data = yahoo_client.historical_quotes(@stock.symbol, { start_date: Time::now-(24*60*60*360), end_date: Time::now }) 
    @open_history = Array.new
    @close_history = Array.new
    @high_history = Array.new
    @low_history = Array.new

    @historical_data.reverse.each do |date_data| 
      date_arr= Array.new
      date_arr.push(date_data['trade_date'])
      date_arr.push(date_data['open'].to_f)
      @open_history.push(date_arr)

      c_date_arr= Array.new
      c_date_arr.push(date_data['trade_date'])
      c_date_arr.push(date_data['close'].to_f)
      @close_history.push(c_date_arr)

      h_date_arr= Array.new
      h_date_arr.push(date_data['trade_date'])
      h_date_arr.push(date_data['high'].to_f)
      @high_history.push(h_date_arr)

      l_date_arr= Array.new
      l_date_arr.push(date_data['trade_date'])
      l_date_arr.push(date_data['low'].to_f)
      @low_history.push(l_date_arr)
    end
    @close_history=@close_history.to_json.html_safe
    @open_history=@open_history.to_json.html_safe
    @high_history=@high_history.to_json.html_safe
    @low_history=@low_history.to_json.html_safe
  end

  def stocks_add
    User_Owns.create(email: current_user.email, symbol: params[:symbol])
    redirect_to dashboard_url
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

end
