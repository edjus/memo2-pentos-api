Dado('el cliente {string}') do |username|
  @username = username
  @request ||= {}
  @request['username'] = username
end

Dado('el nombre del repartidor {string}') do |username|
  @request ||= {}
  @request['username'] = username
end

Cuando('se registra con domicilio {string} y telefono {string}') do |address, phone|
  @request ||= {}
  @request['address'] = address
  @request['phone'] = phone
  @response = Faraday.post(CLIENT_BASE_URL, @request.to_json, header)
end

Cuando('se registra') do
  @response = Faraday.post(REGISTER_DELIVERY_URL, @request.to_json, header)
end

Entonces('obtiene un numero unico de cliente') do
  expect(@response.status).to eq(200)
  parsed_response = JSON.parse(@response.body)
  @client_id = parsed_response['client_id']
  expect(@client_id).to be > 0 # rubocop:disable Style/NumericPredicate
end

Entonces('obtiene un mensaje de error: {string}') do |mensaje_error|
  expect(@response.status).to eq(400)
  parsed_response = JSON.parse(@response.body)
  expect(parsed_response['error']).to eq(mensaje_error)
end

Entonces('obtiene un numero unico de repartidor') do
  expect(@response.status).to eq(200)
  parsed_response = JSON.parse(@response.body)
  expect(parsed_response['delivery_id']).to be > 0 # rubocop:disable Style/NumericPredicate
end

Entonces('obtiene un error por nombre de usuario invalido') do
  expect(@response.status).to eq(400)
  parsed_response = JSON.parse(@response.body)
  expect(parsed_response['error']).to eq('invalid_username')
end
