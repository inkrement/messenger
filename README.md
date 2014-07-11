messenger
======
[![Build Status](https://drone.io/github.com/inkrement/messenger/status.png)](https://drone.io/github.com/inkrement/messenger/latest)

a simple messaging framework for dart. it will support webrtc and some sort of local message passing.


Documentation
========

The messenger library consists of 5 sublibraries (message, events, signaling, connections and peer).

(In the next line <- stands for the include relation)

messenger <- peer <- connections <- signaling <- events <- message

