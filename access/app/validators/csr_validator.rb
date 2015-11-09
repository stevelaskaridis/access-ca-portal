require 'helpers/x509_helpers'

class CsrValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless X509Helpers.valid_csr? value
      record.errors[attribute] << (options[:message] || "is not a valid CSR.")
    end
  end
end