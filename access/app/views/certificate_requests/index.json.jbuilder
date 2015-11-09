json.array!(@certificate_requests) do |certificate_request|
  json.extract! certificate_request, :id, :uuid, :status,
  json.url certificate_request_url(certificate_request, format: :json)
end
