require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'erb'

pin = "1234"
client = Twilio::REST::Client.new 'ACf99cfbc0f42bb061e1dfed9ff6b168b4', 'f434ce9f001c0bc8cb770d85b6d861cd'
twilio_number = '+15148001174'
gate_number = '+16046081352'
front_door_number = '+16046081539'
test = '+17782288756' 

numbers = [
  {:index => 0, :number => '+15149417619', :active => true}
]

nextIndex = 1

get '/' do
  erb :index, :locals => {
    :numbers => numbers 
  }
end

get '/buzzer' do
  if params[:From] == gate_number || params[:From] == front_door_number || params[:From] == test
    Twilio::TwiML::Response.new do |r|
      numbers.each { |x| r.Dial x[:number] }
    end
  end
end

post '/request' do
  content = params[:Body]

  if content == pin
    if numbers.detect{|f| f[:number] == params[:From]} == nil
      numbers.push({
        :index => nextIndex,
        :number => params[:From],
        :active => true
      })
      nextIndex += 1
      message = "Your number has been added to the buzzer list. Press 9 when the gate calls to let yourself in!"
    else
      message = "Your number is already on the list."
    end
  elsif content.downcase == 'remove'
    numbers = numbers.reject { |i| i[:number] == params[:From] }
    message = "Your number has been removed from the buzzer list."
  else
    message = "Whatever you were trying to do, it didn't work."
  end

  twiml = Twilio::TwiML::Response.new do |r|
    r.Sms message
  end
  twiml.text

end
