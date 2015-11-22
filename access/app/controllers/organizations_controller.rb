class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy]

  # GET /organizations
  # GET /organizations.json
  def index
    @organizations = Organization.all
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
    @locales = APP_CONFIG['available_locales'].map { |locale| locale.to_sym }
    @locales -= [params[:locale].to_sym]
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(organization_params)
    @locales = APP_CONFIG['available_locales'].map { |locale| locale.to_sym }
    @locales -= [params[:locale].to_sym]
    org_locales_params = {}
    @locales.each do |locale|
      org_locales_params[locale.to_sym] = {name: nil, description: nil}
      org_locales_params[locale.to_sym][:name] = params["name_#{locale}"] if params["name_#{locale}"]
      org_locales_params[locale.to_sym][:description] = params["description_#{locale}"] if params["description_#{locale}"]
    end

    org_locales_params.each do |locale, hash|
      Globalize.with_locale(locale) do
        @organization.name = hash[:name] if hash[:name]
        @organization.description = hash[:description] if hash[:description]
      end
    end
    respond_to do |format|
      if @organization.save
        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to organizations_url, notice: 'Organization was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      params.require(:organization).permit(:name, :domain, :description)
    end
end
