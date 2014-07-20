/**
 * MessagePassing
 * 
 * simple example for a bidirectional local (in browser-) signaling channel
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */


part of messenger.signaling;

class MessagePassing extends SignalingChannel{
  MessagePassing otherside;
  
  /**
   * connect
   * 
   * Map key is the name of the SignalingChannel.
   * @ TODO: add custom Exceptions
   *  * prevent self-connections
   */
  void connect(Map<String, MessagePassing> options){
    if(options.isEmpty)
      throw new StateError("empty option set excatly one value expected. none found!");
    if(options.values.first == null)
      throw new StateError("first element is null, should be a messagepassing object!");
    
    this.otherside = options.values.first;
  }
  
  /**
   * send message
   * 
   * creates new message and sends it to 
   * the other MessagePassing object
   */
  send(MessengerMessage message){
    otherside.newMessageController.add(new NewMessageEvent(message));
  }
  
  /**
   * close
   */
  close(){
    //TODO: close newMessageController
    
    connection_completer.complete("connection closed");
  }
  
  /**
   * identityMap
   * 
   * returns a map with a reference to this object
   */
  
  Map<String, MessagePassing> identityMap(){
    return {this.hashCode: this};
  }
  
}