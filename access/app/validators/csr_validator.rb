require 'helpers/x509_helpers'

class CsrValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.csr_type == 'classic'
      if country = APP_CONFIG['registration']['accept_csr_only_from_country']
        unless X509Helpers.valid_csr?(value) and CertificateAuthority::SigningRequest.from_x509_csr(value).
            distinguished_name.x509_name.to_s =~ /C=#{country.upcase}\/O=.*\/OU=.*\/CN=.*/
          record.errors[attribute] << (options[:message] || "is not a valid CSR.")
        end
      else
        unless X509Helpers.valid_csr?(value) and CertificateAuthority::Certificate.from_x509_csr(value).
            distinguished_name.x509_name.to_s=~ /C=[A-Z]{2}\/O=.*\/OU=.*\/CN=.*/
          record.errors[attribute] << (options[:message] || "is not a valid CSR.")
        end
      end
    elsif record.csr_type == 'spkac'
      distinguished_name = value.split("/SPKAC=")[0]
      if country = APP_CONFIG['registration']['accept_csr_only_from_country']
        unless X509Helpers.valid_spkac_csr?(value) and distinguished_name =~ /C=#{country.upcase}\/O=.*\/OU=.*\/CN=.*/
          record.errors[attribute] << (options[:message] || "is not a valid CSR.")
        end
      else
        unless X509Helpers.valid_spkac_csr?(value) and distinguished_name =~ /C=#{country.upcase}\/O=.*\/OU=.*\/CN=.*/
            distinguished_name.x509_name.to_s=~ /C=[A-Z]{2}\/O=.*\/OU=.*\/CN=.*\/SPKAC=.* /
          record.errors[attribute] << (options[:message] || "is not a valid CSR.")
        end
      end
    end
  end
end