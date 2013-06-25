StackHaus Buzzer
===============

Twilio-powered buzzer control system for [StackHaus](http://fullstack.ca/stackhaus).

## Overview

StackHaus has both a gate and a front door that you need to bust through in order to get up to the 6th floor. Currently, the buzzer requests come in to a Twilio-powered phone number and then forwards to two cell phones. If the people who own those phones aren't in the office, no one can be buzzed up.

How do we let a rotating list of phones be on the round-robin buzzer list? Enter, the StackHaus Buzzer (aka SHB).

## Outline

* built using Ruby / Sinatra and deployed via Heroku
* interface is through SMS and a PIN
* text the SHB number with the PIN to get yourself added
* text the SHB number "stop" to be removed from the list
* optional: +time in hours to be auto-removed
* optional: front door buzzer always rings 9 if gate called in last 5 minutes
* optional: auto-response before 8am and after 6pm "we are closed" unless someone has added themselves to buzz list






