class InstitutionalEmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless is_institutional(value)
      record.errors[attribute] << "is not an institutional mail"
    end
  end

  private
  def is_institutional(email)
    orgs = Organization.all.map {|d| d.domain}
    (orgs += APP_CONFIG['registration']['additional_orgs_for_mails']) if APP_CONFIG['registration']['additional_orgs_for_mails']
    orgs.each do |o|
      if email =~ /#{o}$/
        return true
      end
    end
    false
  end
end