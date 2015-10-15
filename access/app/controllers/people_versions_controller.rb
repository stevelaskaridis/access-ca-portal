class PeopleVersionsController < ApplicationController
  def index
    @person = Person.find(params[:person_id])
    @person_versions = @person.versions
  end
end
