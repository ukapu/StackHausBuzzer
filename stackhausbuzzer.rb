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
test = '+17782288756' 

DB = Sequel.connect(ENV['DATABASE_URL'])
numbers = DB[:numbers]

get '/' do
  erb :index, :locals => {
    :numbers => numbers
  }
end

post '/buzzer' do

  if params[:From] == ENV['GATE'] || params[:From] == ENV['FRONT_DOOR']  || params[:From] == test
    if Time.now.localtime.hour < 18 || Time.now.localtime.hour > 8
      Twilio::TwiML::Response.new do |r|
        numbers.each { |x| r.Dial x[:number], :timeout => "5" }
      end.text
    else
      Twilio::TwiML::Response.new do |r|
        r.Say 'We are currently closed. Come back during business hours.', :voice => 'woman'
      end.text
    end
  end

end

post '/request' do
  from = params[:From]
  content = params[:Body]
  if content == ENV['PIN']
    if numbers.where(:number => from).count == 0 
      if from == ENV['ADMIN']
        numbers.insert(:number => from, :time_added => Time.now.to_s, :admin => true)
      else
        numbers.insert(:number => from, :time_added => Time.now.to_s, :admin => false)
      end
      message = "Your number has been added to the buzzer list. Press 9 when the gate calls to let yourself in!"
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
