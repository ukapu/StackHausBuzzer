require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'erb'
require 'json'
require 'pp'
require 'sequel'
#require './env.rb'

jfile = "numbers.json"
client = Twilio::REST::Client.new 'ACf99cfbc0f42bb061e1dfed9ff6b168b4', 'f434ce9f001c0bc8cb770d85b6d861cd'

DB = Sequel.connect(ENV['DATABASE_URL'])
numbers = DB[:numbers]

get '/' do
  erb :index, :locals => {
    :numbers => numbers
  }
end

post '/buzzer' do
  if params[:From] == ENV['GATE'] || params[:From] == ENV['FRONT_DOOR']
    Twilio::TwiML::Response.new do |r|
      numbers.each { |x| r.Dial x[:number] }
    end.text
  end
end

post '/request' do
  from = params[:From]
  content = params[:Body]
  if content == ENV['PIN']
    if numbers.where(:number => from).count == 0 
      numbers.insert(:number => from)
      message = "Your number has been added to the buzzer list. Press 9 when the gate calls to let the caller in!"
    else
      message = "Your number is already on the list."
    end
  elsif content.downcase == 'remove'
    numbers.where(:number => from).delete
    message = "Your number has been removed from the buzzer list."
  else
    message = "Whatever you were trying to do, it didn't work."
  end

  twiml = Twilio::TwiML::Response.new do |r|
    r.Sms message
  end
  twiml.text

end
