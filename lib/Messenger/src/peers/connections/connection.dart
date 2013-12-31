part of messenger;

abstract class Connection{
  SignalingChannel sc;
  ReadyState readyState;
  StreamController<ReadyState> readyStateEvent;
  ///new message event stream
  StreamController<NewMessageEvent> newMessageController;
  Logger log;
  
  ///completer for connection
  ///TODO: use another generic type
  Completer<String> connection_completer;
  Completer<String> listen_completer;
  
  Connection([Logger logger=null]){
    if (logger == null) this.log = new Logger("Connection");
    else this.log = logger;
    
    //init
    listen_completer = new Completer<String>();
    connection_completer = new Completer<String>();
    newMessageController = new StreamController<NewMessageEvent>();
  }
  
  /**
   * setter: readyState
   * 
   * @ TODO: make private
   */
  changeReadyState(ReadyState readyState){
    //break if nothing will change
    if (this.readyState == readyState) return;
    
    log.fine("change state: " + readyState.name);
    
    this.readyState = readyState;
    readyStateEvent.add(readyState);
  }
  
  send(Message msg);
  
}
