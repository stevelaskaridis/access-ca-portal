class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale

  def current_user
    @current_user || Person.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    redirect_to login_url unless current_user
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

end
