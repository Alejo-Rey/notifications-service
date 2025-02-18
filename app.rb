require 'sinatra'
require 'json'

post '/notifications' do
  request.body.rewind
  data = JSON.parse(request.body.read)

  puts "Notification received: #{data}"
  status 201
  content_type :json
  { message: "test message" }.to_json
end
