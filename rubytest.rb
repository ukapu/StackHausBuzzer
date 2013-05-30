require 'rubygems'
require 'twilio-ruby'
require 'sinatra'

get '/' do
  'supppp' + Twilio::VERSION

end

