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


post '/addNumber' do
  if params[:Body] == pin 
    numbers.push({
      :index => nextIndex,
      :number => params[:From],
      :active => true
    })

  nextIndex += 1
  content_type 'text/xml'
  erb :twiml

  else
    content_type 'text/xml'
    erb :fail
  end

end
