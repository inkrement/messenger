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
      newMessageController.add(new NewMessageEvent(Message.fromString(message)));
    }
  
  /**
   * connect
   * 
   * @ TODO: add custom Exceptions
   *  * prevent self-connections
   */
  void connect(var options){
    // register callback
    context.callMethod('JSRegisterRecCallback', [recCallback]);
  }
  
  /**
   * send message
   */
  send(Message message) => context.callMethod('JSSignalingsend', [Message.serialize(message)]);
  
  /**
   * close
   */
  close(){
    connection_completer.complete("connection closed");
  }

  
}