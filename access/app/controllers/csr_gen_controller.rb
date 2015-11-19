class CsrGenController < ApplicationController

  def mozilla_csr
    @person = Person.find(params[:user_id])
  end

  def csr_submission
    @person = Person.find(params[:user_id])

    uniqueid = Digest::SHA1::hexdigest Time.now.to_f.to_s
    countryName = params[:countryName]
    organizationName = params[:organizationName]
    organizationalUnitName = params[:organizationalUnitName]
    commonName = params[:commonName]
    spkac = params[:SPKAC]
    date = Date.today.to_s
    requestor_id = params[:user_id]
    body = 'C=' + countryName + "\n" + 'O=' + organizationName + "\n" + 'OU=' + organizationalUnitName + "\n" + 'CN=' + commonName + "\n" + "SPKAC=" + spkac

    org_id = @person.organization.id
    @csr = CertificateRequest.new( :created_at => date, :updated_at => date, :body => body, :uuid =>uniqueid, :csr_type => 'spkac', :requestor_id => requestor_id ,  :status => 'pending', :owner_dn_id => requestor_id, :organization_id => org_id )

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
