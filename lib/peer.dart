library peer;


class Message{
  
}


abstract class Peer{
  List<Peer> _connections;
  
  connect(Peer other);
  
  send(Peer to);
  
  broadcast(List<Peer> to){
    to.forEach((Peer p){
      this.send(p);
    });
  }
  
  multicast() => broadcast(_connections);
  
  //TODO: event
  Message onreceive();
  close();
}

class MessagePassingPeer extends Peer{
  connect(MessagePassingPeer p){
    //TODO: connect?!
    _connections.add(p);
  }
  
  send(MessagePassingPeer p){
    
  }
}


abstract class Network{
  List<Peer> _peers;
  
  
}