require 'helpers/x509_helpers'

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
    if country = APP_CONFIG['registration']['accept_csr_only_from_country']
      if dn =~ /\A\/C=#{country.upcase}\/O=.*\/OU=.*\..*\/CN=[A-Z][a-z]* [A-Z][a-z]*\z/
        true
      else
        false
      end
    else
      if dn =~ /\A\/C=[A-Z]{2}\/O=.*\/OU=.*\..*\/CN=[A-Z][a-z]* [A-Z][a-z]*\z/
        true
      else
        false
      end
    end
  end

  def self.is_valid_host_dn?(dn)
    if country = APP_CONFIG['registration']['accept_csr_only_from_country']
      if dn =~ /\A\/C=#{country.upcase}\/O=.*\/OU=.*\..*\/CN=[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?*\z/
        true
      else
        false
      end
    else
      if dn =~ /\A\/C=[A-Z]{2}\/O=.*\/OU=.*\..*\/CN=[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?*\z/
        true
      else
        false
      end
    end

  end
end

# TODO: Add validation for alternative emails-hostnames as a configurable check.