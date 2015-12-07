require 'helpers/x509_helpers'

class DnValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.owner_type == 'Person'
      unless value =~ /\A\/C=[A-Z]{2}\/O=.*\/OU=.*\..*\/CN=[A-Z][a-z]* [A-Z][a-z]*\z/
        record.errors[attribute] << (options[:message] || "is not a valid Person DN.")
      end
    elsif record.owner_type == 'Host'
      unless value =~ /\A\/C=[A-Z]{2}\/O=.*\/OU=.*\..*\/CN=[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?*\z/
        record.errors[attribute] << (options[:message] || "is not a valid Host DN.")
      end
    end
  end
end