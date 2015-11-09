require 'helpers/x509_helpers'

class DnValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A\/C=[A-Z]{2}\/O=.*\/OU=.*\..*\/CN=[A-Z][a-z]* [A-Z][a-z]*\z/
      record.errors[attribute] << (options[:message] || "is not a valid DN.")
    end
  end
end