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
  
  Map<int, Connection> _connections;
  
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
    _connections = new Map<int, Connection>();
    
    listen_completer = new Completer<String>();
    connection_completer = new Completer<String>();
    
    log.info("new peer: #${num.toString()} ${this.name} ");
    

    peers.add(this);
  }
  
  /**
   * connections getter
   */
  Map<int, Connection> get connections => _connections;
  
  /**
   * get identifer of this object
   */
  String get id => this.hashCode.toString();
  
  /**
   * number of connections
   * 
   * @param ReadyState filter. count only connections with this readyState
   * @returns number of connections
   */
  
  int countConnections([ReadyState filter=null]){
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
  Stream<NewConnectionEvent> listen(SignalingChannel other);
  
  /**
   * connect to another peer
   * 
   * @param Peer other
   */
  Stream<NewConnectionEvent> connect(SignalingChannel other);
  
  /**
   * send Message to other peer
   * 
   * @param String receiverId receiver of message
   * @param Message msg is content of message
   */
  send(int receiverId, Message msg);
  
  /**
   * send string to other peer
   */
  sendString(int receiverId, String msg) => send(receiverId, new Message(msg));
  
  /**
   * send message to multiple peers
   */
  broadcast(Iterable<int> receiverIds, Message msg){
    receiverIds.forEach((int id){
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


/*
//Signaling
 * 
static const ReadyState STABLE = const ReadyState('STABLE', 1);
static const ReadyState HAVE_LOCAL_OFFER = const ReadyState('HAVE_LOCAL_OFFER', 2);
static const ReadyState HAVE_REMOTE_OFFER = const ReadyState('HAVE_REMOTE_OFFER', 3);
static const ReadyState HAVE_LOCAL_PRANSWER = const ReadyState('HAVE_LOCAL_PRANSWER', 4);
static const ReadyState HAVE_REMOTE_PRANSWER = const ReadyState('HAVE_REMOTE_PRANSWER', 5);
*/

