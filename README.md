Dart-Messenger
======
[![Build Status](https://drone.io/github.com/inkrement/messenger/status.png)](https://drone.io/github.com/inkrement/messenger/latest)

This is just a simple messaging framework for dart. it will support webRTC's Datachannel, 
some sort of local message passing and TCP for signaling. 
The main purpose was to create a basis application for university. I wanted to check, if it's possible to create some sort
of "pure p-2-p network within the browser".

You will find a chrome application within the example folder. It uses tcp for signaling and creates a datachannel chat between two peers.

Documentation
=============

The messenger library consists of 5 sublibraries (message, events, signaling, connections and peer). 
You can find the latest API documentation in the Link section.

(In the next line <- stands for the include relation)

messenger <- peer <- connections <- signaling <- events <- message


Build
-----

To build the library just run `build.sh`.

Try it out
----------

It's very easy to try it out. All you need is a dart installation for building and a chrome browser. 
Open the console, jump into the subfolder `example` and build the application by running `pub build`. 
Now you have to open your browser, go to the extention-manager and install a unpacked application (you have to choose the subfolder `example/build/web`).

Links
=====

[Pub.dartlang.org](http://pub.dartlang.org/packages/messenger) project page.
[API Documentation](http://www.dartdocs.org/documentation/messenger/0.0.6/index.html#messenger)