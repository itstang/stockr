class StaticPagesController < ApplicationController

  def home
  end

  def help
  end

  def about
  end

  def dashboard

  end

  def stocks
    y_client = YahooFinance::Client.new
    @stocks = Stock.all
    @data = y_client.quotes(@stocks.pluck(:symbol), [:day_value_change, :bid])
  end

  def rankings

  end

  def history

  end

  def contact

  end

end
