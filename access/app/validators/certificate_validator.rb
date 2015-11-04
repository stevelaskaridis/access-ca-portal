class CertificateValidator < ActiveModel::Validator
  def validate(record)
    if DistinguishedName.find(record.distinguished_name_id).owner_type == 'Person' and
        Certificate.where(distinguished_name_id: record.distinguished_name_id, status: 'valid').count > 0
      record.errors[:status] << 'This person already has a valid certificate.'
    end
  end

end