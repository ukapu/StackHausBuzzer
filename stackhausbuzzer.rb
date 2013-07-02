require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'erb'
require 'json'
require 'pp'
require 'sequel'
#require './env.rb'

DB = Sequel.connect(ENV['DATABASE_URL'])
numbers = DB[:numbers]

get '/' do
  erb :index, :locals => {
    :numbers => numbers
  }
end

post '/buzzer' do

  if params[:From] == ENV['GATE'] || params[:From] == ENV['FRONT_DOOR']  || params[:From] == ENV['TEST']
    if Time.now.localtime.hour < 18 || Time.now.localtime.hour > 8
      Twilio::TwiML::Response.new do |r|
        numbers.each { |x| r.Dial x[:number], :timeout => "10" }
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
        numbers.insert(:number => from, :time_added => Time.now.to_i, :admin => true)
        message = "Your number has been added to the buzzer list with admin privileges. Press 9 when the gate calls to let the caller in!"
      else
        numbers.insert(:number => from, :time_added => Time.now.to_i, :admin => false)
        message = "Your number has been added to the buzzer list. Press 9 when the gate calls to let the caller in!"
      end
    else
      message = "Your number is already on the list."
    end
  elsif content.downcase == 'remove'
    if numbers.where(:number => from).count > 0
      numbers.where(:number => from).delete
      message = "Your number has been removed from the buzzer list."
    else
      message = "You can't remove a number that's not on the list! That ain't how it works."
    end
  else
    message = "Whatever you were trying to do, it didn't work."
  end
  twiml = Twilio::TwiML::Response.new do |r|
    r.Sms message
  end
  twiml.text

end
