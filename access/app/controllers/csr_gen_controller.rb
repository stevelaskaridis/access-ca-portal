require 'helpers/x509_helpers'

class CsrGenController < ApplicationController

  def mozilla_csr
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

end
