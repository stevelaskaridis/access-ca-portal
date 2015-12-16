xml.instruct!
xml.record do
  render(:partial => 'certificate_requests/csr', :locals => {:builder => xml, certificate_request: @certificate_request })
  xml.status @certificate_request.status
end