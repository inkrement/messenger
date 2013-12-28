part of messenger;

abstract class Peer{
  ///logging object
  final Logger log;
  
  ///number of all local peer instances
  static int num = 0;
  
  ///list of all connected peers
  List<Peer> _connections;
  
  ///name of this peer instance
  String name;
  
  ///new message event stream
  StreamController<NewMessageEvent> newMessageController = new StreamController<NewMessageEvent>.broadcast();
  
  ///ready State of connection
  ///todo: generalize and add to connections to support multiple states
  String readyState;
  
  ///ready State event stream component
  ///todo: generalize and add to connections to support multiple states
  StreamController readyStateEvent;
  
  /**
   * constuctor
   */
  Peer([name=""]): log = new Logger('Peer'), readyState="none"{
    _connections = new List<Peer>();
    
    ///set name of this peer instance
    this.name = (name.length == 0)?"peer" + num.toString():name;
    
    ///setup logging library
    Logger.root.level = Level.FINE;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${this.name}: ${rec.message}');
    });
    
    ///increment number of peers
    num++;
  }
  
  /**
   * setter: readyState
   * 
   * @ TODO: make private
   */
  changeReadyState(String readyState){
    log.info("change state: " + readyState);
    
    this.readyState = readyState;
    readyStateEvent.add(readyState);
  }
  
  /**
   * connect to another peer
   * 
   * @param Peer other
   */
  connect(Peer other);
  
  /**
   * send Message to other peer
   * 
   * @param Peer to receiver of message
   * @param Message msg is content of message
   */
  send(Peer to, Message msg);
  
  /**
   * send string to other peer
   */
  sendString(Peer p, String msg) => send(p, new Message(msg));
  
  /**
   * send message to multiple peers
   */
  broadcast(List<Peer> to, Message msg){
    to.forEach((Peer p){
      this.send(p, msg);
    });
  }
  
  /**
   * send message to all known peers
   */
  multicast(Message msg) => broadcast(_connections, msg);
  
  /**
   * getter: onstream event channel (stream)
   */
  Stream get onReceive => newMessageController.stream;
  
  /**
   * getter: name
   */
  String get getName => this.name;
  
  /**
   * close connection
   */
  close();
}
