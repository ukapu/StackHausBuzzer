StackHaus Buzzer
===============

Twilio-powered buzzer control system for [StackHaus](http://fullstack.ca/stackhaus).

The StackHaus Buzzer maintains a list of numbers which are all dialed in succession when a call comes in from either the front door or the front gate. The list is stored with PostgreSQL, and all the phone-related business is done using the Twilio API. 

If you want to work on the Buzzer, you'll need to install the gems located in the Gemfile, as well as hook the app up to a database of your choice. It's being hosted on Heroku at the moment, but you can host it however you want. Note that Twilio needs for the app to hosted before it can do anything - you can't do any type of local testing. 

If you want to use the buzzer for yourself, here's a few things you need to do:

- Change the enviroment variables FRONT_DOOR and GATE to whatever number(s) you expect to be calling your app.
- Change the app's URL to whatever the URL is you're using to host the app. 
- Change the DATABASE_URL to whatever the database is you're using. 



