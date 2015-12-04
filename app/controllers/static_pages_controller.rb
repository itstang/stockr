require 'twitter.rb'
require "#{Rails.root}/config/initializers/alchemyapi.rb"
require 'nokogiri'
require 'open-uri'
require 'json'

class StaticPagesController < ApplicationController

  def home
  end

  def help
  end

  def about
  end

  def dashboard
    y_client = YahooFinance::Client.new
    @user_watches = User_Watches.joins('LEFT OUTER JOIN stocks ON stocks.symbol = user_watches.symbol').where(email: current_user.email)
    @user_owns = User_Owns.where(email: current_user.email)
    @data_watches = y_client.quotes(@user_watches.pluck(:symbol), [:name, :day_value_change, :bid, :sentiment])
    @data_owns = y_client.quotes(@user_owns.pluck(:symbol), [:name, :day_value_change, :bid, :sentiment])

    @stock_symbols = []
    @stock_shares = []
    @stock_prices = []
    @stock_ids = []

    @user_owns.each_with_index do |stock, index|
      @stock_symbols.push(stock.symbol)
      @stock_shares.push(stock.shares)
      @stock_prices.push(@data_owns[index].bid)
      @stock_ids.push(stock.id)
    end


    @user_watches.each_with_index do |stock, index|
        # @data_watches[index].sentiment= sentiment(stock.symbol)
    end
  end

  def stocks
    @stocks = Stock.all.page(params[:page])
  end

  def stocks_show
    @stock = Stock.find(params[:id])
    @user_owns = User_Owns.new

    # Get media links
    @media_links = scrape_media(Stock.find(params[:id]).symbol)

    yahoo_client = YahooFinance::Client.new

    @stock_data = yahoo_client.quotes([@stock.symbol, "NATU3.SA", "USDJPY=X"], [:ask, :bid, :high, :low, :moving_average_50_day, :moving_average_200_day])
    @historical_data = yahoo_client.historical_quotes(@stock.symbol, { start_date: Time::now-(24*60*60*360), end_date: Time::now })
    @sentiment = sentiment(@stock.symbol, @media_links, @historical_data)

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
    if !Stock.find_by(symbol: params[:symbol]).nil?
      User_Watches.create(email: current_user.email, symbol: params[:symbol])
    end
    redirect_to dashboard_url
  end

  def stocks_remove
    User_Watches.find_by(email: current_user.email, symbol: params[:user_watches][:symbol]).destroy
    flash[:success] = "Stock removed from watchlist"
    redirect_to dashboard_url
  end

  def stocks_buy
    num_shares = params[:user_owns][:shares].to_i
    total_price = params[:user_owns][:price].to_f * num_shares

    user = User.find_by(email: current_user.email)
    user_owns_symbol = User_Owns.where(email: current_user.email, symbol:params[:user_owns][:symbol])
    if total_price > user.balance
      #do nothing
    else
      if user_owns_symbol.empty?
        User_Owns.create(email: current_user.email, symbol: params[:user_owns][:symbol], shares: num_shares)
      else
        user_owns = User_Owns.where(:email => current_user.email, :symbol => params[:user_owns][:symbol])
        user_owns[0].shares += num_shares
        user_owns[0].save
      end

      Transaction.create(transaction_type: "buy", email: current_user.email, symbol: params[:user_owns][:symbol], shares: num_shares, amount: total_price)
      user.balance -= total_price
      user.save
    end
    flash[:success] = "You bought " + num_shares.to_s + " shares of " + params[:user_owns][:symbol].to_s + " for $" + total_price.to_s + "!"
    redirect_to dashboard_url
  end

  def stocks_sell
    num_shares = params[:user_owns][:shares].to_i

    user_owns_symbol = User_Owns.find_by(email: current_user.email, symbol: params[:user_owns][:symbol])
    if user_owns_symbol.nil?
      #do nothing
    else
      if num_shares <= user_owns_symbol.shares
        user_owns_symbol.shares -= num_shares
        user_owns_symbol.save

        if user_owns_symbol.shares == 0
          user_owns_symbol.destroy
        end
      else
        num_shares = 0
      end

      total_price = params[:user_owns][:price].to_f * num_shares
      Transaction.create(transaction_type: "sell", email: current_user.email, symbol: params[:user_owns][:symbol], shares: num_shares, amount: total_price)

      user = User.find_by(email: current_user.email)
      user.balance += total_price
      user.save
    end

    flash[:success] = "You sold " + num_shares.to_s + " share(s) of " + params[:user_owns][:symbol].to_s + " for $" + total_price.to_s + "!"
    redirect_to dashboard_url
  end

  def scrape_media(stock)
    links_arr = Array.new
    links_hash = Hash.new
    url = 'http://finance.yahoo.com/q?s='

    doc = Nokogiri::HTML(open(url+stock))
    scrape_list = doc.css('#yfi_headlines .bd ul li').children
    scrape_list.each do |link|
      if !link.attributes['href'].nil?
        links_hash = {
          'name' => link.text,
          'link' => link.attributes['href'].value.gsub(/.*?(?=\*http)\*/, "")
        }
        links_arr.append(links_hash)
      end
    end
    links_arr
  end

  def moving_avg(period, historical_data)
    simple_MA = 0
    historical_data[0..(period-1)].each do |date_data|
      simple_MA += (date_data['close'].to_f)
    end
    simple_MA /= period

    return simple_MA
  end

  def sentiment(stock_symbol, media_links, historical_data)
    alchemyapi = AlchemyAPI.new()
    num_tweets = 0
    num_media = 0
    total_score = 0
    media_total = 0
    avg_sentiment = 0
    tweet_sentiment = 0
    tweets_hash = Hash.new

    tweets = $twitter.search('$' + stock_symbol + ' -rt',
                               result_type: 'mixed',
                               count: 20).take(50)

    # remove url from tweets
    tweets.each do |tweet|
      tweet_no_url= tweet.text.dup
      tweet_no_url.gsub!(/(?:f|ht)tps?:\/[^\s]+/, '')
      if(tweets_hash.has_key?(tweet_no_url) == false)
        tweets_hash[tweet_no_url]= tweet.user.verified?
      end
    end

    # remove duplicates
    # Get tweet sentiment
    tweets_hash.each do |tweet, verified|
      tweet_sentiment = alchemyapi.sentiment("text", tweet)
      if tweet_sentiment["status"] == 'OK' && tweet_sentiment["docSentiment"]["score"] != nil
        cur_sentiment = tweet_sentiment["docSentiment"]["score"].to_f
        if(verified == true)
          #Double score if a verified Tweeter
          cur_sentiment += cur_sentiment
        end
        total_score += cur_sentiment
        num_tweets= num_tweets + 1
      end
    end

    # Get media sentiment
    media_links[0..5].each do |media|
      media_sentiment = alchemyapi.sentiment('url', media['link'])
      if media_sentiment['status'] == 'OK' && media_sentiment['docSentiment']['score'] != nil
        cur_sentiment = media_sentiment['docSentiment']['score'].to_f

        media_total += cur_sentiment
        num_media += 1
      end
    end

    # Get average tweet sentiment score
    num_tweets == 0 ? tweet_sentiment = 0 : tweet_sentiment = total_score/num_tweets
    # Get average media sentiment score
    num_media == 0 ? media_sentiment = 0 : media_sentiment = media_total/num_media

    avg_sentiment = tweet_sentiment * 0.4 + media_sentiment * 0.6

    twenty_day_exp_MA = moving_avg(20, historical_data)
    fifty_day_exp_MA = moving_avg(50, historical_data)

    puts tweet_sentiment
    puts media_sentiment
    puts avg_sentiment

    if twenty_day_exp_MA < fifty_day_exp_MA && avg_sentiment > 0.25
      return 'Buy'
    elsif twenty_day_exp_MA < fifty_day_exp_MA && avg_sentiment < 0.1
      return 'Sell'
    elsif twenty_day_exp_MA > fifty_day_exp_MA && avg_sentiment > 0.25
      return 'Buy'
    elsif twenty_day_exp_MA > fifty_day_exp_MA && avg_sentiment < 0.1
      return 'Sell'
    else
      return 'Hold'
    end
  end

  def history
    @transactions = Transaction.where(email: current_user.email).order(id: :desc)
  end

  def contact

  end

end
