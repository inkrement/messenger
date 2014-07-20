/**
 * JSCallbacksignaling
 * 
 * simple example for a bidirectional signaling channel based on some undefined js technology
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */

part of messenger.signaling;

class JSCallbackSignaling extends SignalingChannel{
  
  
  void recCallback(String message){
      newMessageController.add(new NewMessageEvent(MessengerMessage.fromString(message)));
    }
  
  /**
   * connect
   * 
   * @ TODO: add custom Exceptions
   *  * prevent self-connections
   */
  void connect(var options){
    // register callback
    
    //FIXME: generates "Uncaught TypeError: Cannot read property 'apply' of undefined"
    //context.callMethod('JSRegisterRecCallback', [recCallback]);
  }
  
  /**
   * send message
   * 
   * TODO: test if function exists
   */
  send(MessengerMessage message) => context.callMethod('JSSignalingsend', [MessengerMessage.serialize(message)]);
  
  /**
   * close
   */
  close(){
    connection_completer.complete("connection closed");
  }
  
}