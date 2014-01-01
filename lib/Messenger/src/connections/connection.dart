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
  
  //private logger
  final Logger _log;
  
  //completer for connection
  //TODO: maybe one. only one will be used
  final Completer<int> _connection_completer;
  final Completer<int> _listen_completer;
  
  /**
   * constructor
   */
  Connection(SignalingChannel sc, Logger log):
    _CSStreamController=new StreamController<ConnectionState>.broadcast(), 
    _listen_completer = new Completer<int>(),
    _connection_completer = new Completer<int>(),
    _newMessageController = new StreamController<NewMessageEvent>(),
    _sc = sc,
    _log = log{
      if(_log == null) throw new StateError("Logger should not be null!");
    }
    
    /**
     * connect to other peer
     * 
     * @return Future<int>
     */
    Future<int> connect();
    
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
   * send Message over communcation channel
   * 
   * @ TODO: pipe message if not open!
   */
  send(Message msg);
  
}
