require 'helpers/x509_helpers'

class CaController < ApplicationController
  def list_approved
    @approved_csrs = CertificateRequest.where(status: 'approved')
  end

  def upload_certs
    params[:records].each do |cert|
      # mark certificate request as signed
      csr = CertificateRequest.find_by_uuid(cert[:uniqueid])
      csr.status = 'signed'
      csr.save

      # Load the signed certificate
      cert = CertificateReader.new(cert[:body]).certificate_obj


      # Create a certificate record
      certificate_record = Certificate.create(
                                :body => cert.openssl_body.to_s,
                                :status => 'not_accepted',
                                :distinguished_name_id => csr.owner_dn.id,
                                :certificate_request_uuid => csr.uuid
                           )

      # TODO: Send e-mail notification to the user
    end
    render :text=>params[:records].size.to_s + " certificates were uploaded\n"
  end
end
