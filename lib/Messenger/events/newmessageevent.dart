library messenger.newmessage;

import 'dart:html';
import '../message.dart';

 /**
  * NewMessageEvent
  * 
  * this event is triggered if a new message receives
  */
class NewMessageEvent implements Event{
  Message data;
  var path;
  var defaultPrevented;
  var currentTarget;
  var clipboardData;
  var cancelable = false;
  var bubbles;
  var type;
  var eventPhase;
  var target;
  var matchingTarget;
  var timeStamp;
  
  NewMessageEvent(Message msg){
    data = msg;
  }
  
  Message getMessage() => data;
}