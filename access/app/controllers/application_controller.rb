class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :set_locale

  helper_method :current_user

  def current_user
    @current_user || Person.find(session[:user_id]) if session[:user_id]
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  protected
  def authorize!
    redirect_to login_url, alert: "#{I18n.t 'controllers.authorization.not_logged_in'}" unless current_user
  end

end
