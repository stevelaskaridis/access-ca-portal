require 'helpers/x509_helpers'

class CertValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless X509Helpers.valid_cert? value
      record.errors[attribute] << (options[:message] || "is not a valid Certificate.")
    end
  end
end