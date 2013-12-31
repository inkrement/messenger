part of messenger.events;


 /**
  * NewMessageEvent
  * 
  * this event is triggered if a new message receives
  */
class NewConnectionEvent implements Event{
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
  
  final Connection data;
  
  NewConnectionEvent(Connection this.data);
  
  Connection getConnection() => data;
}

