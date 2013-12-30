part of messenger;

abstract class Connection<T extends Peer>{
  T partner;
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
  
  send(String msg);
  
}
