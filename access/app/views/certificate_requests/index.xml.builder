xml.instruct!
xml.records(type: 'array') do

  @certificate_requests.each do |certificate_request|
    render(:partial => 'certificate_requests/csr', :locals => {:builder => xml, certificate_request: certificate_request })
    xml.status certificate_request.status
  end
end