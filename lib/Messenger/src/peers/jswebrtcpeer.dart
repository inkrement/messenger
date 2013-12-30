part of messenger;





class JsWebRtcPeer extends Peer{
  
  /**
   * constructor
   */
  JsWebRtcPeer([String name="", Level logLevel=Level.FINE]):super(name, logLevel){  
    
  }
  
  listen(sc){
    
  }
  
  connect(sc){
    
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
    _connections.forEach((Peer p, Connection c)=>disconnect(p));
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