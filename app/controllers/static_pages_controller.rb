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

  end

  def rankings

  end

  def history
    @user ||= User.find(session[:email]) if session[:email]
  end

  def contact
  end
end
