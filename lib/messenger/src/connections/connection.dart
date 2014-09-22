/**
 * class Connection
 * 
 * supports bidirectional connections
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */

part of messenger.connections;

abstract class Connection{
  //state of this communication
  ConnectionState readyState;
  
  //stream controller of Communication State changes
  final StreamController<ConnectionState> _CSStreamController;
  
  //new message event stream
  final StreamController<NewMessageEvent> _newMessageController;
  
  //signaling channel for connecting process
  final SignalingChannel _sc;
  
  //send buffer
  final StreamController<MessengerMessage> _sendController;
  
  
  static final _log = new Logger("messenger.Connection");
  
  //completer for connection
  //TODO: maybe one. only one will be used
  final Completer<int> _connection_completer;
  final Completer<int> _listen_completer;
  
  /**
   * constructor
   */
  Connection(SignalingChannel sc):
    _CSStreamController=new StreamController<ConnectionState>.broadcast(), 
    _listen_completer = new Completer<int>(),
    _connection_completer = new Completer<int>(),
    _newMessageController = new StreamController<NewMessageEvent>(),
    _sc = sc,
    _sendController = new StreamController<MessengerMessage>();
    
    /**
     * connect to other peer
     * 
     * @return Future<int>
     */
    Future<int> connect();
    
    /**
     * listen for incoming connections
     * 
     * @return Future<int>
     */
    Future<int> listen();
  
  /**
   * setter: readyState
   * 
   * @ TODO: make atomic ? semaphores?!
   */
  _setCommunicationState(ConnectionState readyState){
    //break if nothing will change
    if (this.readyState == readyState) return;
    
    _log.fine("change state: " + readyState.name);
    
    this.readyState = readyState;
    _CSStreamController.add(readyState);
    
    // do some connectionstate specific operations
    switch(readyState){
      case ConnectionState.CONNECTED:
        _init_send_worker();
        break;
    }
  }
  
  /**
   * onStateChange (getter)
   * 
   * @return Stream
   */
  Stream<ConnectionState> get onStateChange => _CSStreamController.stream;
  
  /**
   * onMessage (getter)
   * 
   * @return Stream
   */
  Stream<NewMessageEvent> get onMessage => _newMessageController.stream;
  
  /**
   * send
   * 
   * pipe message 
   */
  send(MessengerMessage msg){
    _log.fine("new message added to buffer");
    
    _sendController.add(msg);
  }
  
  sendString(String message){
    MessengerMessage msg = new MessengerMessage(message, MessageType.STRING);
    send(msg);
  }
  
  /**
   * 
   */
  _init_send_worker();
  
  
  close();
}
