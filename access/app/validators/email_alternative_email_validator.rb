class EmailAlternativeEmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if AlternativeEmail.find_by_email(value)
      record.errors[attribute] << (options[:message] || 'already exists')
    end
  end
end