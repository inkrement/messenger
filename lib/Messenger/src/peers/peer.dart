part of messenger;

abstract class Peer{
  final Logger log;
  List<Peer> _connections;
  StreamController<NewMessageEvent> newMessageController = new StreamController<NewMessageEvent>.broadcast();
  
  Peer(): log = new Logger('Peer'){
    _connections = new List<Peer>();
    
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });
    
    
  }
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
