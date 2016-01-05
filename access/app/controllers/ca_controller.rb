require 'helpers/x509_helpers'

class CaController < ApplicationController
  before_filter :authorize!

  def list_approved
    @approved_csrs = CertificateRequest.where(status: 'approved')
  end

  def upload_certs_file
  end

  def upload_certs
    respond_to do |format|
      format.html {
        @cert_hash = Hash.from_xml(File.read(params['certs.xml'].tempfile))#.gsub("\n", ''))
        register_certs
      }
      format.xml {
        # TODO: Check why not available through params hash.
        @cert_hash = Hash.from_xml(request.body.read)#.gsub("\n", ''))
        register_certs
      }
    end
  end

  private
  def ca_params
    params.require('records').permit!
    # params.require('lala').permit!
  end

  def register_certs
    @cert_hash['records'].each do |cert|
      # mark certificate request as signed
      csr = CertificateRequest.find_by_uuid(cert['uniqueid'])
      csr.status = 'signed'
      csr.save!

      # Load the signed certificate
      cert = X509Helpers::CertificateReader.new(cert['body']).certificate_obj


      # Create a certificate record
      certificate_record = Certificate.create(
          :body => cert.openssl_body.to_s,
          :status => 'not_accepted',
          :distinguished_name_id => csr.owner_dn.id,
          :certificate_request_uuid => csr.uuid
      )

      # TODO: Send e-mail notification to the user
      render :text=>@cert_hash['records'].size.to_s + " certificates were uploaded\n"
    end
  end

  private

  def authorize!
    super
    if (current_user && !TmpAdmin.is_admin?(current_user))
      redirect_to root_url, alert: "#{I18n.t 'controllers.authorization.not_authorized'}"
    end
  end
end
