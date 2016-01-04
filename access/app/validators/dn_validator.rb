require 'helpers/x509_helpers'
require 'helpers/type_helpers'

class DnValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.owner_type == 'Person'
      unless DnValidator.is_valid_person_dn? value
        record.errors[attribute] << (options[:message] || "is not a valid Person DN.")
      end
    elsif record.owner_type == 'Host'
      unless DnValidator.is_valid_host_dn? value
        record.errors[attribute] << (options[:message] || "is not a valid Host DN.")
      end
    end
  end

  def self.is_valid_person_dn?(dn)
    name = TypeHelpers::PERSON_NAME_REGEX
    if country = APP_CONFIG['registration']['accept_csr_only_from_country']
      if dn =~ /\A\/C=#{country.upcase}\/O=.*\/OU=.*\..*\/CN=#{name}\z/
        true
      else
        false
      end
    else
      if dn =~ /\A\/C=[A-Z]{2}\/O=.*\/OU=.*\..*\/CN=#{name}\z/
        true
      else
        false
      end
    end
  end

  def self.is_valid_host_dn?(dn)
    hostname = TypeHelpers::HOSTNAME_REGEX
    if country = APP_CONFIG['registration']['accept_csr_only_from_country']
      if dn =~ /\A\/C=#{country.upcase}\/O=.*\/OU=.*\..*\/CN=#{hostname}/
        true
      else
        false
      end
    else
      if dn =~ /\A\/C=[A-Z]{2}\/O=.*\/OU=.*\..*\/CN=#{hostname}/
        true
      else
        false
      end
    end

  end
end

# TODO: Add validation for alternative emails-hostnames as a configurable check.