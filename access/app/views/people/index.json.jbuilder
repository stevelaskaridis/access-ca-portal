json.array!(@people) do |person|
  json.extract! person, :id, :first_name, :last_name, :first_name_latin, :last_name_latin, :email, :position.description, :department,
                :scientific_field.description
  json.url person_url(person, format: :json)
end
