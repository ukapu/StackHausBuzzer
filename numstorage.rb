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
  message = 0
  if content == pin # && !(numbers.detect {|f| f["number"] == params[:From] )
    numbers.push({
      :index => nextIndex,
      :number => params[:From],
      :active => true
    })

    nextIndex += 1
    message = 1
  elseif content.downcase == 'remove'
    numbers = numbers.reject { |i,j,k| j == params[:From] }
    message = 2
  else
    message = 0
  end

  if message == 1
    content_type 'text/xml'
    erb :twiml
  elif message == 2
    content_type 'text/xml'
    erb :remove
  elif message == 0
    content_type 'text/xml'
    erb :fail

end
