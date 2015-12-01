class HostnameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix
      record.errors[attribute] << (options[:message] || "is not a hostname")
    end
  end
end