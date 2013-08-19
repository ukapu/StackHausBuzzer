StackHaus Buzzer
===============

A Twilio-powered buzzer control system using Ruby and Sinatra, made originally for [StackHaus](http://fullstack.ca/stackhaus).

## How it works

The StackHaus Buzzer maintains a list of numbers which are all dialed in succession when a call comes in from either the front door or the front gate. The calls from the gate and door go to the Twilio number, which then routes the call to the appropriate numbers from the list. The list is stored with PostgreSQL, and all the phone-related business is done using the Twilio API. SQL stuff is handled using the [Sequel](http://sequel.rubyforge.org/) gem.

## For users

If you want to let people into the Stack Haus, you'll need to text the password to the given number. You'll then be added to the list of numbers to be called. To remove yourself just text "remove" to the same number. 

If you're the 'admin', you will be called first no matter how many people are on the list. However, the admin will only be called between the hours of 9 and 6. 

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

Now you'll need to set the environment variables, both locally and on heroku. We'll start with the Heroku variables (more info [here](https://devcenter.heroku.com/articles/config-vars).)

heroku config:set 

As a developer, here's a few things you need to do:

- Change the enviroment variables FRONT_DOOR and GATE to whatever number(s) you expect to be calling your app.
- Change the app's URL to whatever the URL is you're using to host the app.
- Change the DATABASE_URL to whatever the database is you're using. 


