class InstitutionalEmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless is_institutional(value)
      record.errors[attribute] << "is not an institutional mail"
    end
  end

  private
  def is_institutional(email)
    orgs = Organization.all.map {|d| d.domain}
    orgs << %w(cern.ch upnet.gr)
    orgs.each do |o|
      if email =~ /#{o}$/
        return true
      end
    end
    false
  end
end