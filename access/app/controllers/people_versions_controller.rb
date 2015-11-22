class PeopleVersionsController < ApplicationController
  before_filter :authorize!
  def index
    @person = Person.find(params[:person_id])
    @person_versions = @person.versions
  end

  private
  def authorize!
    redirect_to people_url, alert: "#{I18n.t 'controllers.authorization.not_authorized'}" unless TmpAdmin.is_admin?(current_user)
  end
end
