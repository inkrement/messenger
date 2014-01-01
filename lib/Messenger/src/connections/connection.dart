part of messenger.connections;

abstract class Connection{
  final SignalingChannel _sc;
  ReadyState readyState;
  final StreamController<ReadyState> readyStateEvent;
  ///new message event stream
  final StreamController<NewMessageEvent> newMessageController;
  final Logger _log = new Logger("Connection");
  
  ///completer for connection
  final Completer<int> _connection_completer;
  final Completer<int> _listen_completer;
  
  
  Connection(SignalingChannel sc, [Level loglevel=Level.OFF]):
    readyStateEvent=new StreamController<ReadyState>.broadcast(), 
    _listen_completer = new Completer<int>(),
    _connection_completer = new Completer<int>(),
    newMessageController = new StreamController<NewMessageEvent>(),
    _sc = sc{ _log.level = loglevel; }
  
  /**
   * setter: readyState
   * 
   * @ TODO: make private
   */
  changeReadyState(ReadyState readyState){
    //break if nothing will change
    if (this.readyState == readyState) return;
    
    _log.fine("change state: " + readyState.name);
    
    this.readyState = readyState;
    readyStateEvent.add(readyState);
  }
  
  send(Message msg);
  
}
