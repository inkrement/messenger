part of messenger;

/**
 * @todo: 
 *  * ready Status enum instead of string
 */

abstract class Peer{
  ///logging object
  static final Logger parent_log = new Logger("Peer");
  
  //list of all local peers
  static Map<String, Peer> peers;
  
  Logger log;
  
  ///number of all local peer instances
  static int num = 0;
  
  ///list of all connected peers
  List<Peer> _connections;
  
  ///name of this peer instance
  String name;
  
  ///new message event stream
  StreamController<NewMessageEvent> newMessageController;
  
  ///ready State of connection
  ///todo: generalize and add to connections to support multiple states
  ReadyState readyState;
  
  ///ready State event stream component
  ///todo: generalize and add to connections to support multiple states
  StreamController<ReadyState> readyStateEvent;
  
  ///completer for connection
  ///TODO: use another generic type
  Completer<String> connection_completer;
  Completer<String> listen_completer;
  
  /**
   * constuctor
   * 
   * todo: name has to be unique
   */
  Peer([String name="", Level logLevel=Level.FINE]){
    this.name = (name.length < 1)?"peer" + (++num).toString():name; //set name of this peer instance
    
    if(peers.keys.contains(this.name))
      throw new StateError("peer with name ${this.name} already exists!");
    
    //setup logger
    hierarchicalLoggingEnabled = true;
    log = new Logger("Peer.${this.runtimeType}.${this.name}");
    log.level = logLevel;   
    log.onRecord.listen((LogRecord rec) {
      print('${rec.loggerName} (${rec.level.name}): ${rec.message}');
    });
    
    connection_completer = new Completer<String>();
    listen_completer = new Completer<String>();
    readyStateEvent = new StreamController<ReadyState>.broadcast();
    newMessageController = new StreamController<NewMessageEvent>.broadcast(); 
    
    _connections = new List<Peer>();
    readyState=ReadyState.NEW;
    
    log.info("new peer: #${num.toString()} ${this.name} ");
    
    //add instance reference to peerlist
    peers[this.name] = this;
  }
  
  /**
   * setter: readyState
   * 
   * @ TODO: make private
   */
  changeReadyState(ReadyState readyState){
    //break if nothing will change
    if (this.readyState == readyState) return;
    
    log.fine("change state: " + readyState.name);
    
    this.readyState = readyState;
    readyStateEvent.add(readyState);
  }
  
  /**
   * listen for incoming connections
   * 
   * @param Peer other
   */
  Future listen(SignalingChannel other);
  
  /**
   * connect to another peer
   * 
   * @param Peer other
   */
  Future connect(SignalingChannel other);
  
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


/*
//Signaling
 * 
static const ReadyState STABLE = const ReadyState('STABLE', 1);
static const ReadyState HAVE_LOCAL_OFFER = const ReadyState('HAVE_LOCAL_OFFER', 2);
static const ReadyState HAVE_REMOTE_OFFER = const ReadyState('HAVE_REMOTE_OFFER', 3);
static const ReadyState HAVE_LOCAL_PRANSWER = const ReadyState('HAVE_LOCAL_PRANSWER', 4);
static const ReadyState HAVE_REMOTE_PRANSWER = const ReadyState('HAVE_REMOTE_PRANSWER', 5);
*/

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