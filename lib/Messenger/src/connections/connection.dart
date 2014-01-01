/**
 * class Connection
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */


part of messenger.connections;

abstract class Connection{
  final SignalingChannel _sc;
  ConnectionState readyState;
  final StreamController<ConnectionState> readyStateEvent;
  ///new message event stream
  final StreamController<NewMessageEvent> newMessageController;
  final Logger _log;
  
  ///completer for connection
  final Completer<int> _connection_completer;
  final Completer<int> _listen_completer;
  
  
  Connection(SignalingChannel sc, Logger log):
    readyStateEvent=new StreamController<ConnectionState>.broadcast(), 
    _listen_completer = new Completer<int>(),
    _connection_completer = new Completer<int>(),
    newMessageController = new StreamController<NewMessageEvent>(),
    _sc = sc,
    _log = log{
      if(_log == null) throw new StateError("Logger should not be null!");
    }
    
    
    Future<int> connect();
    
    Future<int> listen();
  
  /**
   * setter: readyState
   * 
   * @ TODO: make private
   */
  changeReadyState(ConnectionState readyState){
    //break if nothing will change
    if (this.readyState == readyState) return;
    
    _log.fine("change state: " + readyState.name);
    
    this.readyState = readyState;
    readyStateEvent.add(readyState);
  }
  
  /**
   * sendMessage
   */
  send(Message msg);
  
}
