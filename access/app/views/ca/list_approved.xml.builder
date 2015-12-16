xml.instruct!
xml.records(type: 'array') do

  @approved_csrs.each do |certificate_request|
    render(:partial => 'certificate_requests/csr', :locals => {:builder => xml, certificate_request: certificate_request })
  end
end