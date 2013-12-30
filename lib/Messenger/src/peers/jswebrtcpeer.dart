part of messenger;

class JsWebRtcPeer extends Peer{
  
  /**
   * constructor
   */
  JsWebRtcPeer([String name="", Level logLevel=Level.FINE]):super(name, logLevel){  
    
  }
  
  listen(SignalingChannel sc){
    JsWebRtcConnection<JsWebRtcPeer> c = new JsWebRtcConnection<JsWebRtcPeer>(log);
    Future<String> f = c.listen(sc);
    
    //add to list of connections. index is identity of other peer
    //TODO: test if identity is unique
    f.then((String hash) => _connections[hash] = c);
  }
  
  connect(SignalingChannel sc){
    JsWebRtcConnection<JsWebRtcPeer> c = new JsWebRtcConnection<JsWebRtcPeer>(log);
    Future<String> f = c.connect(sc);
    
    f.then((String hash) => _connections[hash] = c);
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
  send(JsWebRtcPeer o, Message msg){
    log.info("send message!");
    
    if(!_connections.containsKey(o))
      throw new StateError("list of connections does not contain peer ${o.name}");
    
    _connections[o].send(msg.toString());
  }
  
}