require 'helpers/x509_helpers'

class CertificateRequestsController < ApplicationController
  before_action :set_certificate_request, only: [:show, :edit, :update, :destroy]

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
    X509Helpers.csr_creation(@certificate_request, params)

    respond_to do |format|
      if @certificate_request.save
        format.html { redirect_to certificate_requests_url, notice: 'Certificate request was successfully created.' }
        format.json { render :show, status: :created, location: @certificate_request }
      else
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
    flash[:notice] = 'called approve'
    redirect_to certificate_requests_url
  end

  def reject_csr
    flash[:notice] = 'called reject'
    redirect_to certificate_requests_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_certificate_request
      @certificate_request = CertificateRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def certificate_request_params
      params.require(:certificate_request).permit(:body)
    end
end
