class SessionsController < ApplicationController

  def new

  end

  def create
    user = Person.find_by_email(params[:email])
    if user
      session[:user_id] = user.id
      redirect_to root_url
    else
      redirect_to login_url
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url
  end
end
