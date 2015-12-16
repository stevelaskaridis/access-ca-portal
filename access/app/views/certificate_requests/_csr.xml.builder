builder.tag! ('owner-type') do
  builder.text! certificate_request.owner_dn.owner_type
end
builder.body certificate_request.body
builder.tag!('csr-type') do
  builder.text! certificate_request.csr_type
end
builder.uniqueid certificate_request.uuid
builder.altnames(type: 'array') do
  certificate_request.extract_alternative_names.each do |alt_name|
    builder.altname alt_name
  end
end