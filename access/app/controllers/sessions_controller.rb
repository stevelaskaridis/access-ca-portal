class SessionsController < ApplicationController
  skip_before_action :authorize!, [:create, :new]

  def new

  end

  def create
    user = Person.find_by_email(params[:email])
    if user
      session[:user_id] = user.id
      response.headers['X-CSRF-Token'] = form_authenticity_token
      redirect_to root_url, locale: params[:locale], notice: "#{I18n.t 'controllers.session.welcome'}"
    else
      redirect_to login_url, flash: { error: "#{I18n.t 'controllers.session.invalid_email'}" }
    end
  end

  def destroy
    reset_session
    redirect_to login_url
  end
end
