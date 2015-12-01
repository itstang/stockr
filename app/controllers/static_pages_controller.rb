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
    @graph= histogram(@stock.symbol)
  end

  def histogram(stock_symbol)
    yahoo_client = YahooFinance::Client.new
    historical_data = yahoo_client.historical_quotes(stock_symbol, { start_date: Time::now-(24*60*60*21), end_date: Time::now })

    graph = Gruff::Line.new(600)
    graph.title = 'Three Week History of ' + stock_symbol

    x_axis = []

    historical_data.each { |row|  x_axis << row['trade_date'] }
    start_date = x_axis.min
    middle_date = x_axis[(x_axis.length ) / 2]
    end_date = x_axis.max

    graph.labels = { 0 => start_date, 7 => middle_date, 13 => end_date }

    open_history = Array.new
    close_history = Array.new
    high_history = Array.new
    low_history = Array.new

    historical_data.each do |date_data| 
      open_history.push(date_data['open'].to_f)
      close_history.push(date_data['close'].to_f)
      high_history.push(date_data['high'].to_f)
      low_history.push(date_data['low'].to_f)
    end

    graph.data('Open', open_history, '#B75582')
    graph.data('High', high_history, '#79C65B' )
    graph.data('Low', low_history)
    graph.data('Close', close_history)

    graph.x_axis_label = 'Date'
    graph.y_axis_label = 'Dollars'

    send_data(graph.to_blob, :filename => "stock.png", :type => 'image/png', :disposition=> 'inline')
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
