require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'erb'
require 'json'
require 'pp'
require 'sequel'

jfile = "numbers.json"
client = Twilio::REST::Client.new 'ACf99cfbc0f42bb061e1dfed9ff6b168b4', 'f434ce9f001c0bc8cb770d85b6d861cd'
twilio_number = '+15148001174'
test = '+17782288756' 
dburl = ENV['DATABASE_URL']
DB = Sequel.connect(dburl)

def jwrite(object, file)
  File.open(file, "w+") do |f|
    JSON.dump(object,f)
  end
end

def jread(file)
  File.open(file, "r") do |f|
    j = JSON.load(f)
  end
end

numbers = [ { :number => '+15149417619'} ]

#jwrite(numbers, jfile)

get '/' do
  numbers = jread(jfile)
  erb :index, :locals => {
    :numbers => numbers
  }
end

post '/buzzer' do
  numbers = jread(jfile)
  if params[:From] == ENV['GATE'] || params[:From] == ENV['FRONT_DOOR']  || params[:From] == test
    Twilio::TwiML::Response.new do |r|
      numbers.each { |x| r.Dial x[:number] }
    end.text
  end
end

post '/request' do
  content = params[:Body]
  numbers = jread(jfile)
  if content == ENV['PIN']
    if numbers.detect{|f| f["number"] == params[:From]} == nil
      numbers.push({
        "number" => params[:From]
      })
      message = "Your number has been added to the buzzer list. Press 9 when the gate calls to let yourself in!"
    else
      message = "Your number is already on the list."
    end
  elsif content.downcase == 'remove'
    numbers = numbers.reject { |i| i["number"] == params[:From] }
    message = "Your number has been removed from the buzzer list."
  else
    message = "Whatever you were trying to do, it didn't work."
  end

  jwrite(numbers, jfile)

  twiml = Twilio::TwiML::Response.new do |r|
    r.Sms message
  end
  twiml.text

end
