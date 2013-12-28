part of messenger;

abstract class Peer{
  final Logger log;
  static int num = 0;
  List<Peer> _connections;
  String name;
  StreamController<NewMessageEvent> newMessageController = new StreamController<NewMessageEvent>.broadcast();
  
  Peer([name=""]): log = new Logger('Peer'){
    _connections = new List<Peer>();
    
    this.name = (name.length == 0)?"peer" + num.toString():name;
    
    Logger.root.level = Level.FINE;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${this.name}: ${rec.message}');
    });
    
    //increment number of peers
    num++;
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
