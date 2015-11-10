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
    body = 'C=' + countryName + "\n" + 'O=' + organizationName + "\n" + 'OU=' + organizationalUnitName + "\n" + 'CN=' + commonName + "\n" + spkac

    @csr = CertificateRequest.new(:id => requestor_id, :created_at => date, :updated_at => date, :body => body, :uuid =>uniqueid, :csr_type => 'spkac', :requestor_id => requestor_id ,  :status => 'pending' )

    if @csr.save
      render :inline => '<pre><%= @csr.body %></pre>'
    end


  end
  

end
