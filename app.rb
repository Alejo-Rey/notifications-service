require 'sinatra'
require 'json'
require 'mail'
require 'letter_opener'
require 'debug'

set :bind, '0.0.0.0'
set :port, 3003
set :environment, :production
set :protection, origin_whitelist: ['http://orders-service:3003', 'http://localhost:3003']

Mail.defaults do
  delivery_method Mail::FileDelivery, location: './tmp/mails'
end

post '/notifications' do

  request.body.rewind
  data = JSON.parse(request.body.read)

  user_email = data["email"]
  order_id = data["order_id"]
  message = data["message"]

  send_email(user_email, order_id, message)

  status 201
  content_type :json
  { message: "message" }.to_json
end

def send_email(to, order_id, message)
  Mail.deliver do
    from    "notificaciones@miapp.com"
    to      to
    subject "Notification for your order ##{order_id}"
    body    message
  end
end
