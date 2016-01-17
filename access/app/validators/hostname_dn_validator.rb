require 'hostname_validator'

class HostnameDnValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    hostname = CertificateAuthority::SigningRequest.from_x509_csr(value).distinguished_name.x509_name.to_s.split('/')[4].split('=')[1]
    unless HostnameValidator.hostname_format_valid? hostname
      record.errors[attribute] << (options[:message] || "is not a hostname")
    else
      unless HostnameValidator.hostname_dns_valid? hostname
        record.errors[attribute] << ("could not be resolved")
      end
    end
  end
end