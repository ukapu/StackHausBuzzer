StackHaus Buzzer
===============

Twilio-powered buzzer control system for [StackHaus](http://fullstack.ca/stackhaus).

## Overview

StackHaus has both a gate and a front door that you need to bust through in order to get up to the 6th floor.

How do we let a rotating list of phones be on the round-robin buzzer list? Enter, the StackHaus Buzzer (aka SHB).

## Outline

* built using Ruby / Sinatra and deployed via Heroku
* interface is through SMS and a PIN
* text the SHB number with the PIN to get yourself added
* text the SHB number "remove" to be removed from the list
* auto-response before 8am and after 6pm "we are closed" unless someone has added themselves to buzz list

## To-Do

* optional: +time in hours to be auto-removed
* optional: front door buzzer always rings 9 if gate called in last 5 minutes
* admin functions so that certain people can remove other people's numbers





