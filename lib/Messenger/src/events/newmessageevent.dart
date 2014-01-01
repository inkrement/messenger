part of messenger.events;


 /**
  * NewMessageEvent
  * 
  * this event is triggered if a new message receives
  */
class NewMessageEvent implements Event{
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
  
  /**
   * @ TODO: implement
   */
  void stopImmediatePropagation(){}
  
  /**
   * @ TODO: implement
   */
  void preventDefault(){}
  
  /**
   * @ TODO: implement
   */
  void stopPropagation(){}
  
  final Message data;
  
  NewMessageEvent(this.data);
  
  Message getMessage() => data;
}

