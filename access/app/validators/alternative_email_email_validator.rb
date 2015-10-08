class AlternativeEmailEmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if Person.exists? email: value
      record.errors[attribute] << (options[:message] || 'already exists')
    end
  end
end