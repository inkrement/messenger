part of messenger;

abstract class Peer{
  List<Peer> _connections;
  StreamController<NewMessageEvent> newMessageController = new StreamController<NewMessageEvent>.broadcast();
  
  connect(Peer other);
  
  send(Peer to, Message msg);
  sendString(Peer p, String msg) => send(p, new Message(msg));
  
  broadcast(List<Peer> to, Message msg){
    to.forEach((Peer p){
      this.send(p, msg);
    });
  }
  
  multicast(Message msg) => broadcast(_connections, msg);
  
  Stream get onReceive => newMessageController.stream;
  
  close();
}
