part of messenger.events;


 /**
  * NewMessageEvent
  * 
  * this event is triggered if a new message receives
  * 
  * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
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
  
  final Connection data;
  
  NewConnectionEvent(Connection this.data);
  
  Connection getConnection() => data;
}

