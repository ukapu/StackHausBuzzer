StackHaus Buzzer
===============

A Twilio-powered buzzer control system using Ruby and Sinatra, made originally for [StackHaus](http://fullstack.ca/stackhaus).

## How it works

The StackHaus Buzzer maintains a list of numbers which are all dialed in succession when a call comes in from either the front door or the front gate. The calls from the gate and door go to the Twilio app number, which then routes the call to the appropriate numbers from the list. The list is stored with PostgreSQL, and all the phone-related business is done using the Twilio API. SQL stuff is handled using the [Sequel](http://sequel.rubyforge.org/) gem.

## For users

If you want to be able to let people in, you'll need to text the password to the given number. You'll then be added to the list of numbers to be called. To remove yourself just text "remove" to the same number. 

If you're the 'admin', you will be called first no matter how many people are on the list. However, the admin will only be called between the hours of 9 and 6. You'll also be able to clear all non-admin numbers from the list by texting 'admin clear' to the app number.

## For developers

If you want to work on the Buzzer, you'll need to install the gems located in the Gemfile, as well as hook the app up to a database of your choice in order to store the numbers. It's being hosted on Heroku at the moment, but you can host it however you want. Note that Twilio needs the app to hosted before it can do anything - you can't do any type of local testing aside from checking syntax.
Here are some setup instructions for Heroku and Postgres. See [this guide](https://devcenter.heroku.com/articles/heroku-postgresql) for detailed info on setting up a Postgres DB with Heroku.

Clone the git repo.
<pre>
git clone https://github.com/FullStackFoundry/StackHausBuzzer.git
</pre>
Install the required gems
<pre>
bundle install
</pre>
Create a new Heroku app.
<pre>
heroku app:create [app name]
</pre>
Install the Heroku Postgres add-on and create a new database.
<pre>
heroku addons:add heroku-postgresql:dev 
</pre>
Find the URL of your database.
<pre>
heroku config | grep HEROKU_POSTGRESQL
</pre>
Promote the database to primary db.
<pre>
heroku pg:promote [database url]
</pre>

Now you'll need to set the environment variables, both locally and on heroku. We'll start with the Heroku variables (more info [here](https://devcenter.heroku.com/articles/config-vars).) Setting a heroku env. variable looks like this:
<pre>
heroku config:set PIN=[pin] 
</pre>
And so on and so forth. You should at least be setting the PIN variable and one of either the FRONT_DOOR and GATE variables, the names of which are just holdovers from the way the buzzer works here at StackHaus. The buzzer will only accept calls from specified numbers, which in our case are the gate and the front door. Obviously you can change the names of the variables as you wish. The ADMIN variable is useful if you have one person who is taking most of the buzzer calls. Set ADMIN to their phone number and they won't get calls after hours (default hours are 9 to 6) or on weekends, and they'll be able to clear the list of non-admin numbers by texting "admin clear".

The other thing you need to do is change the url that the app calls to whatever url you're using to host your app. This will be found in the buzzer.rb file. The app makes a call to youapp.com/continue when it's going through the list of numbers. 


Then, you get a Twilio number hooked up to the app. Change the SMS request url to POST to "yourapp.com/request" and the voice request to POST to "yourapp.com/buzzer".

Finally, push your app to heroku, or whatever you're using to host the app.
