require 'helpers/x509_helpers'

class CsrValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.owner_dn_id && DistinguishedName.find(record.owner_dn_id).owner_type == 'Person'
      if record.csr_type == 'classic'
        distinguished_name = CertificateAuthority::SigningRequest.from_x509_csr(value).
            distinguished_name.x509_name.to_s
        unless CsrValidator.valid_person_csr(value, distinguished_name)
          record.errors[attribute] << (options[:message] || "is not a valid CSR.")
        end
      elsif record.csr_type == 'spkac'
        distinguished_name = value.split("/SPKAC=")[0]
        unless CsrValidator.valid_person_csr(value, distinguished_name)
          record.errors[attribute] << (options[:message] || "is not a valid CSR.")
        end
      end
    elsif record.owner_dn_id && DistinguishedName.find(record.owner_dn_id).owner_type == 'Host'
      # support only for terminal created csr
      distinguished_name = CertificateAuthority::SigningRequest.from_x509_csr(value).
          distinguished_name.x509_name.to_s
      unless CsrValidator.valid_host_csr(value, distinguished_name)
        record.errors[attribute] << (options[:message] || "is not a valid CSR.")
      end
    end
  end

  def self.valid_person_csr(csr, distinguished_name)
    email=/([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})/
    if country = APP_CONFIG['registration']['accept_csr_only_from_country']
      unless (X509Helpers.valid_csr?(csr) || X509Helpers.valid_spkac_csr?(csr)) and
          (distinguished_name =~ /\A(\/C=#{country.upcase}\/O=.*\/OU=.*\..*\/CN=[A-Z][a-z]* [A-Z][a-z]*)(\/subjectAltName=(email.[1-9]\d*=#{email})(,(email.[1-9]\d*=#{email}))*)?\z/) == 0
        return false
      end
    else
      unless (X509Helpers.valid_csr?(csr) || X509Helpers.valid_spkac_csr?(csr)) and
          (distinguished_name =~ /\A(\/C=[A-Z]{2}\/O=.*\/OU=.*\..*\/CN=[A-Z][a-z]* [A-Z][a-z]*)(\/subjectAltName=(email.[1-9]\d*=#{email})(,(email.[1-9]\d*=#{email}))*)?\z/) == 0
        return false
      end
    end
    return true
  end

  def self.valid_host_csr(csr, distinguished_name)
    hostname = /\A[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix
    if country = APP_CONFIG['registration']['accept_csr_only_from_country']
      unless X509Helpers.valid_csr?(csr) and
          (distinguished_name =~ /\A(\/C=#{country.upcase}\/O=.*\/OU=.*\..*\/CN=[A-Z][a-z]* [A-Z][a-z]*)(\/subjectAltName=(DNS.[1-9]\d*=#{hostname})(,(DNS.[1-9]\d*=#{hostname}))*)?\z/) == 0
        return false
      end
    else
      unless X509Helpers.valid_csr?(csr) and
          (distinguished_name =~ /\A(\/C=[A-Z]{2}\/O=.*\/OU=.*\..*\/CN=[A-Z][a-z]* [A-Z][a-z]*)(\/subjectAltName=(DNS.[1-9]\d*=#{hostname})(,(DNS.[1-9]\d*=#{hostname}))*)?\z/) == 0
        return false
      end
    end
  end
end