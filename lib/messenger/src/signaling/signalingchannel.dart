
/**
 * SignalingChannel
 * 
 * bidirectional communication channel to establish peer connections
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 * @version 1
 */


part of messenger.signaling;

abstract class SignalingChannel{
  StreamController<NewMessageEvent> newMessageController;
  final Completer<String> connection_completer = new Completer<String>();
  StreamController<SignalingChannelEvents> newEventsController;
  
  /**
   * constructor
   */
  SignalingChannel(){
    ///init
    newMessageController = new StreamController<NewMessageEvent>.broadcast();
    newEventsController = new StreamController<SignalingChannelEvents>.broadcast();
  }
  
  /**
   * unique identifer
   */
  int get id => this.hashCode;
  
  /**
   * establish connection
   */
  void connect(var options);
  
  /**
   * send String to other side of Channel
   */
  send(MessengerMessage);
  
  /**
   * listen for incoming messages
   */
  Stream get onReceive => newMessageController.stream;
  
  
  /**
   * listen for incoming messages
   */
  Stream get onEvent => newEventsController.stream;
  
  /**
   * close connection and free ressources
   */
  close();
}