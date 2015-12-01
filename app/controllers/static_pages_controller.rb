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
    @data = y_client.quotes(@stocks.pluck(:symbol), [:name, :day_value_change, :bid])
  end

  def stocks_add
    Stock.create(symbol: params[:symbol])

    redirect_to stocks_url
  end

  def rankings

  end

  def history

  end

  def contact

  end

end
