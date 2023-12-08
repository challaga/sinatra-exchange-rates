require "sinatra"
require "sinatra/reloader"
require "http"
require "json"


# define a route
get("/") do
  "
  <h1>Welcome to your Sinatra App!</h1>
  <p>Define some routes in app.rb</p>
  "

  # build the API url, including the API key in the query string

  api_url = "https://api.exchangerate.host/list?access_key=fa37e94f30043729bbef4e8a0bb21d65"

  # use HTTP.get to retrieve the API information
  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)

  parsed_data.inspect

  @symbols = parsed_data['currencies'].keys

  erb(:homepage)
end

get("/:from_currency") do
  @original_currency = params.fetch("from_currency")

  api_url = "https://api.exchangerate.host/list?access_key=fa37e94f30043729bbef4e8a0bb21d65"

  raw_data = HTTP.get(api_url)
  parsed_data = JSON.parse(raw_data.to_s)

  @symbols = parsed_data['currencies'].keys - [@original_currency]

  erb :choose_currency

end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")

  api_url = "https://api.exchangerate.host/convert?access_key=fa37e94f30043729bbef4e8a0bb21d65&from=#{@original_currency}&to=#{@destination_currency}&amount=1"

  raw_data = HTTP.get(api_url)

  parsed_data = JSON.parse(raw_data.to_s)

  parsed_data.inspect

  @conversion_rate = parsed_data['result']

  erb :specific_conversion
end
