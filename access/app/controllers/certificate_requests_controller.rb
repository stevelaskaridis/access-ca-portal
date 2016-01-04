require 'helpers/x509_helpers'

class CertificateRequestsController < ApplicationController
  before_action :set_certificate_request, only: [:show, :edit, :update, :destroy]
  before_filter :authorize!

  # GET /certificate_requests
  # GET /certificate_requests.json
  def index
    @certificate_requests = CertificateRequest.all
  end

  # GET /certificate_requests/1
  # GET /certificate_requests/1.json
  def show
  end

  # GET /certificate_requests/new
  def new
    @certificate_request = CertificateRequest.new
  end

  # GET /certificate_requests/1/edit
  def edit
  end

  # POST /certificate_requests
  # POST /certificate_requests.json
  def create
    @certificate_request = CertificateRequest.new(certificate_request_params)
    @certificate_request.requestor = current_user
    X509Helpers.csr_creation(@certificate_request, params, session)

    respond_to do |format|
      if @certificate_request.save
        format.html { redirect_to certificate_requests_url, notice: 'Certificate request was successfully created.' }
        format.json { render :show, status: :created, location: @certificate_request }
      else
        # The form only shows the CSR body, so all errors have to relate to this field.
        if (@certificate_request.errors['body'])
          @certificate_request.errors.each do |k,v|
            @certificate_request.errors.delete(k) unless k == :body
          end
        end
        format.html { render :new }
        format.json { render json: @certificate_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /certificate_requests/1
  # PATCH/PUT /certificate_requests/1.json
  def update
    respond_to do |format|
      if @certificate_request.update(certificate_request_params)
        format.html { redirect_to @certificate_request, notice: 'Certificate request was successfully updated.' }
        format.json { render :show, status: :ok, location: @certificate_request }
      else
        format.html { render :edit }
        format.json { render json: @certificate_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /certificate_requests/1
  # DELETE /certificate_requests/1.json
  def destroy
    @certificate_request.destroy
    respond_to do |format|
      format.html { redirect_to certificate_requests_url, notice: 'Certificate request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def approve_csr
    begin
      CertificateRequest.approve_csr(params[:certificate_request_id])
    rescue InvalidActionError => e
      redirect_to certificate_requests_url, flash: { error: "#{e.message}" }
      return
    end
    redirect_to certificate_requests_url, notice: "Updated!"
  end

  def reject_csr
    begin
      CertificateRequest.reject_csr(params[:certificate_request_id])
    rescue InvalidActionError => e
      redirect_to certificate_requests_url, flash: { error: "#{e.message}" }
      return
    end
    redirect_to certificate_requests_url, notice: "Updated!"
  end

  #################### Mozilla Generated CSRs ####################
  ################################################################

  def mozilla_csr
    @country = APP_CONFIG['registration']['accept_csr_only_from_country']
    @person = Person.find(params[:user_id])
  end

  def csr_submission
    @csr = CertificateRequest.new(requestor_id: current_user.id)
    X509Helpers.csr_spkac_creation(@csr, params)

    if @csr.save
      render :inline => '<pre><%= @csr.body %></pre>'
    else
      redirect_to action: 'error_csr_sub'
    end

  end

  def error_csr_sub
  end

  def csr_value
    email = params[:emailAddress]
    @person = Person.find_by(:email => email)
    if @person
      id = @person.id
      @status = CertificateRequest.find_by(:id => id)
      if @status
        render :inline => '<pre><%= @status.status %></pre>'
      else
        redirect_to :action => "error"
      end
    else
      redirect_to :action => "error"
    end

  end

  def error
  end

  ################################################################

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_certificate_request
      @certificate_request = CertificateRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def certificate_request_params
      params.require(:certificate_request).permit(:body)
    end

    def authorize!
      super
      if @certificate_request && (@certificate_request.requestor_id != current_user.id) && (!TmpAdmin.is_admin?(current_user))
        redirect_to certificate_requests_url, alert: "#{I18n.t 'controllers.authorization.not_authorized'}"
      end
    end
end
