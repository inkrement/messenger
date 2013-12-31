part of messenger;

/**
 * @todo: 
 *  * ready Status enum instead of string
 */

abstract class Peer{
  ///root logging object
  static final Logger parent_log = new Logger("Peer");
  
  Logger log;
  
  StreamController<NewConnectionEvent> newConnectionController;
  
  ///number of all local peer instances
  static int num = 0;
  
  ///name of this peer instance
  String name;
  
  ///new message event stream
  StreamController<NewMessageEvent> newMessageController;
  
  Map<String, Connection> _connections;
  
  static List<Peer> peers = new List<Peer>();
 
  //object is identified by hash of name. name has to be unique
  int get hashCode => this.name.hashCode;
  
  Completer<String> connection_completer;
  Completer<String> listen_completer;
  
  /**
   * constuctor
   * 
   */
  Peer([String name="", Level logLevel=Level.FINE]){
    //set name of this peer instance
    this.name = (name.length < 1)?"peer" + (++num).toString():name; 
    
    //is name is unique?
    if(peers.contains(this))
      throw new StateError("peer with name ${this.name} already exists!");
    
    //setup logger
    hierarchicalLoggingEnabled = true;
    log = new Logger("Peer.${this.runtimeType}.${this.name}");
    log.level = logLevel;   
    log.onRecord.listen((LogRecord rec) {
      print('${rec.loggerName} (${rec.level.name}): ${rec.message}');
    });
    
    //init
    newMessageController = new StreamController<NewMessageEvent>.broadcast();
    newConnectionController = new StreamController<NewConnectionEvent>.broadcast();
    _connections = new Map<String, Connection>();
    
    listen_completer = new Completer<String>();
    connection_completer = new Completer<String>();
    
    log.info("new peer: #${num.toString()} ${this.name} ");
    

    peers.add(this);
  }
  
  /**
   * number of connections
   * 
   * @param ReadyState filter. count only connections with this readyState
   * @returns number of connections
   */
  
  int connections([ReadyState filter=null]){
    int i=0;
    
    _connections.forEach((k,v){
      if(filter==null)  return i++;
      else if(v.readyState == filter) i++;
    });
    
    return i;
  }
  
  
  
  /**
   * listen for incoming connections
   * 
   * @param Peer other
   */
  Stream listen(SignalingChannel other);
  
  /**
   * connect to another peer
   * 
   * @param Peer other
   */
  Stream connect(SignalingChannel other);
  
  /**
   * send Message to other peer
   * 
   * @param String receiverId receiver of message
   * @param Message msg is content of message
   */
  send(String receiverId, Message msg);
  
  /**
   * send string to other peer
   */
  sendString(String receiverId, String msg) => send(receiverId, new Message(msg));
  
  /**
   * send message to multiple peers
   */
  broadcast(List<String> receiverIds, Message msg){
    receiverIds.forEach((String id){
      this.send(id, msg);
    });
  }
  
  /**
   * send message to all known peers
   */
  multicast(Message msg) => broadcast(_connections.keys, msg);
  
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

class ReadyState{
  final String name;
  final int value;
  
  //init value
  static const ReadyState NEW = const ReadyState._create('NEW', 0);
  
  //RTC
  static const ReadyState RTC_NEW = const ReadyState._create('RTC_NEW', 1);
  static const ReadyState RTC_CONNECTING = const ReadyState._create('RTC_CONNECTING', 2);
  static const ReadyState RTC_CONNECTED = const ReadyState._create('RTC_CONNECTED', 3);
  static const ReadyState RTC_COMPLETED = const ReadyState._create('RTC_COMPLETED', 4);
  static const ReadyState RTC_FAILED = const ReadyState._create('RTC_FAILED', 5);
  static const ReadyState RTC_DISCONNECTED = const ReadyState._create('RTC_DISCONNECTED', 6);
  static const ReadyState RTC_CLOSED = const ReadyState._create('RTC_CLOSED', 7);
  
  //DC
  static const ReadyState DC_CONNECTING = const ReadyState._create('DC_CONNECTING', 8);
  static const ReadyState DC_OPEN = const ReadyState._create('DC_OPEN', 9);
  static const ReadyState DC_CLOSING = const ReadyState._create('DC_CLOSING', 10);
  static const ReadyState DC_CLOSED = const ReadyState._create('DC_CLOSED', 11);
  
  //Undefined status
  static const ReadyState UNDEFINED = const ReadyState._create('UNDEFINED', 100);
  
  const ReadyState._create(this.name, this.value);
  
  factory ReadyState.fromDataChannel(String name){
    switch(name){
      case "connecting":
        return const ReadyState._create('DC_CONNECTING', 11);
      case "open":
        return const ReadyState._create('DC_OPEN', 9);
      case "closing":
        return const ReadyState._create('DC_CLOSING', 10);
      case "closed":
        return const ReadyState._create('DC_CLOSED', 11);
      default:
        return const ReadyState._create('UNDEFINED', 100);
    }
  }
}
/*
//Signaling
 * 
static const ReadyState STABLE = const ReadyState('STABLE', 1);
static const ReadyState HAVE_LOCAL_OFFER = const ReadyState('HAVE_LOCAL_OFFER', 2);
static const ReadyState HAVE_REMOTE_OFFER = const ReadyState('HAVE_REMOTE_OFFER', 3);
static const ReadyState HAVE_LOCAL_PRANSWER = const ReadyState('HAVE_LOCAL_PRANSWER', 4);
static const ReadyState HAVE_REMOTE_PRANSWER = const ReadyState('HAVE_REMOTE_PRANSWER', 5);
*/

