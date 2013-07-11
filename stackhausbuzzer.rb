require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'erb'
require 'json'
require 'pp'
require 'sequel'
require 'tzinfo'


DB = Sequel.connect(ENV['DATABASE_URL'])
numset = DB[:numbers]
numbers = []
tz = TZInfo::Timezone.get('Canada/Pacific')

get '/' do
  erb :index, :locals => {
    :numbers => numset
  }
end

post '/buzzer' do

  hr = tz.utc_to_local(Time.now).hour
  time = tz.utc_to_local(Time.now)

  if params[:From] == ENV['GATE'] || params[:From] == ENV['FRONT_DOOR']  || params[:From] == ENV['TEST'] 
    if ( hr > 18 || hr < 8 ) || ( time.saturday? || time.sunday? )
      if numset.where(:admin => 'f').count == 0
        Twilio::TwiML::Response.new do |r|
          r.Say 'We are currently closed. Come back during business hours.'
        end.text
      else
        numbers = numset.where(:admin => 'f').all
        out = numbers.pop
        Twilio::TwiML::Response.new do |r|
          r.Dial out[:number], :action => "http://stackhausstaging.herokuapp.com/buzzer/continue", :timeout => 18
        end.text
      end
    else
      numbers = numset.order(:admin).all
      out = numbers.pop
      Twilio::TwiML::Response.new do |r|
        r.Dial out[:number], :action => "http://stackhausstaging.herokuapp.com/buzzer/continue", :timeout => 15
      end.text
    end
  end

end

post '/buzzer/continue' do

  status = params[:DialCallStatus]
  if numbers.empty?
    Twilio::TwiML::Response.new do |r|
      r.Say 'Sorry. No one seems to be picking up their phone at the moment.'
    end.text
  else
    if status == "busy" || status == "failed" || status == "no-answer"
      out = numbers.pop
      Twilio::TwiML::Response.new do |r|
        r.Say 'Calling next number. Please wait.'
        r.Dial out[:number], :callerId => params[:From], :action => "http://stackhausstaging.herokuapp.com/buzzer/continue", :timeout => 20    
      end.text
    else
      Twilio::TwiML::Response.new do |r|
        r.Say 'Goodbye'
      end.text
    end
  end

end



post '/request' do

  from = params[:From]
  content = params[:Body]

  if content == ENV['PIN']
    if numset.where(:number => from).count == 0 
      if from == ENV['ADMIN']
        numset.insert(:number => from, :time_added => Time.now.to_i, :admin => true)
        message = "Your number has been added to the buzzer list with admin privileges. Press 9 when the gate calls to let the caller in!"
      else
        numset.insert(:number => from, :time_added => Time.now.to_i, :admin => false)
        message = "Your number has been added to the buzzer list. Press 9 when the gate calls to let the caller in!"
      end
    else
      message = "Your number is already on the list."
    end
  elsif content.downcase == 'remove'
    if numset.where(:number => from).count > 0
      numset.where(:number => from).delete
      message = "Your number has been removed from the buzzer list."
    else
      message = "You can't remove a number that's not on the list! That ain't how it works."
    end
  elsif content.downcase == 'admin clear'
    if from == ENV['ADMIN']
      numset.where(:admin => 'f').delete
      message = "Non admin numbers have been cleared. (If there were any)."
    else
      message = "You're not allowed to do that."
    end
  else
    message = "Whatever you were trying to do, it didn't work."
  end

  twiml = Twilio::TwiML::Response.new do |r|
    r.Sms message
  end
  twiml.text

end
