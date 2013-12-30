part of messenger;

class JsWebRtcPeer extends Peer{
  
  /**
   * constructor
   */
  JsWebRtcPeer([String name="", Level logLevel=Level.FINE]):super(name, logLevel){  
    
  }
  
  Future listen(SignalingChannel sc){
    JsWebRtcConnection c = new JsWebRtcConnection(log);
    Future<String> f = c.listen(sc);
    
    //add to list of connections. index is identity of other peer
    //TODO: test if identity is unique
    f.then((String hash){
      _connections[hash] = c; 
      listen_completer.complete("wuhuu");
    });
    
    return listen_completer.future;
  }
  
  Future connect(SignalingChannel sc){
    JsWebRtcConnection c = new JsWebRtcConnection(log);
    Future<String> f = c.connect(sc);
    
    f.then((String hash) {
      _connections[hash] = c;
      connection_completer.complete("wuhuu");
    });
    
    return connection_completer.future;
  }
 
  
  /**
   * disconnect Peer
   */
  disconnect(JsWebRtcPeer o){
    //TODO: abort rtc connection
    //close Datachannel
    
    _connections.remove(o);
  }
  
  
  
  /**
   * close Connection
   * 
   * TODO: implementation
   */
  close(){
    //_connections.forEach((Peer p, Connection c)=>disconnect(p));
  }
  
  
  
  /**
   * send Message
   * 
   * @ TODO: check if datachannel open. else throw exception
   */
  send(String name, Message msg){
    log.info("send message!");
    
    if(!_connections.containsKey(o))
      throw new StateError("list of connections does not contain peer ${o.name}");
    
    _connections[o].send(msg.toString());
  }
  
}