StackHaus Buzzer
===============

Twilio-powered buzzer control system for [StackHaus](http://fullstack.ca/stackhaus).

The StackHaus Buzzer maintains a list of numbers which are all dialed in succession when a call comes in from either the front door or the front gate. The list is stored with PostgreSQL, and all the phone-related business is done using the Twilio API. 

If you want to let people into the Stack Haus, you'll need to text the password to the given number. You'll then be added to the list of numbers to be called. To remove yourself just text "remove" to the same number. 

If you're the admin, you will be called first no matter how many people are on the list. However, the admin will only be called between the hours of 9 and 6. 

If you want to work on the Buzzer, you'll need to install the gems located in the Gemfile, as well as hook the app up to a database of your choice. It's being hosted on Heroku at the moment, but you can host it however you want. Note that Twilio needs for the app to hosted before it can do anything - you can't do any type of local testing aside from checking syntax.

If you want to use the buzzer for yourself, here's a few things you need to do:

- Change the enviroment variables FRONT_DOOR and GATE to whatever number(s) you expect to be calling your app.
- Change the app's URL to whatever the URL is you're using to host the app. 
- Change the DATABASE_URL to whatever the database is you're using. 

Debugging the buzzer is a relatively involved process.

