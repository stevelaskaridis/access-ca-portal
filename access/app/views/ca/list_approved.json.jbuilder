json.array!(@approved_csrs) do |certificate_request|
  json.partial! 'certificate_requests/csr', certificate_request: certificate_request
  json.status certificate_request.status
end
