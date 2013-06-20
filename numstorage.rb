require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'erb'

pin = "1234"
client = Twilio::REST::Client.new 'ACf99cfbc0f42bb061e1dfed9ff6b168b4', 'f434ce9f001c0bc8cb770d85b6d861cd'
twilio_number = '15148001174'

numbers = [
  {:index => 0, :number => '5149417619', :active => true}
]

nextIndex = 1

get '/' do
  erb :index, :locals => {
    :numbers => numbers 
  }
end


post '/request' do

  content = params[:Body]

  if content == pin

    numbers.push({
      :index => nextIndex,
      :number => params[:From],
      :active => true
    })

    nextIndex += 1
    message = "Your number has been added to the buzzer list."

  elsif content.downcase == 'remove'
    numbers = numbers.reject { |i,j,k| j == params[:From] }
    message = "Your number has been removed from the buzzer list."
  else
    message = "Whatever you were trying to do, it didn't work."
  end

  twiml = Twilio::TwiML::Response.new do |r|
    r.Sms message
  end
  twiml.text

#  if message == 1
#    content_type 'text/xml'
#    erb :twiml
#  elif message == 2
#    content_type 'text/xml'

end
