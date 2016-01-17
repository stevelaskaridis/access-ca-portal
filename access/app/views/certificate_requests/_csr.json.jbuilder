json.extract! certificate_request, :body
json.set! 'unique-id', certificate_request.uuid
json.set! 'csr-type', certificate_request.csr_type
json.set! 'owner-type', certificate_request.owner_dn.owner_type
json.altnames certificate_request.extract_alternative_names(show_order: true)