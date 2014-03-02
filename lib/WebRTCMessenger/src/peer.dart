/**
 * class Peer
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */

library messenger.peer;

import 'package:logging/logging.dart';
import 'dart:async';

import 'connections.dart';
export 'connections.dart';

/*
 * @todo: 
 *  * ready Status enum instead of string
 */

class Peer{
  ///root logging object
  static final Logger parent_log = new Logger("Peer");
  
  Logger _log;
  
  StreamController<NewConnectionEvent> newConnectionController;
  
  ///number of all local peer instances
  static int num = 0;
  
  ///name of this peer instance
  String name;
  
  Level _loglevel;
  
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
  Peer([String name="", Level loglevel=Level.FINE]){
    //set name of this peer instance
    this.name = (name.length < 1)?"peer" + (++num).toString():name; 
    
    //is name is unique?
    if(peers.contains(this))
      throw new StateError("peer with name ${this.name} already exists!");
    
    //setup logger
    hierarchicalLoggingEnabled = true;
    _log = new Logger("Peer.${this.runtimeType}.${this.name}");
    _log.level = loglevel;   
    _log.onRecord.listen((LogRecord rec) {
      print('${rec.loggerName} (${rec.level.name}): ${rec.message}');
    });
    
    //init
    newMessageController = new StreamController<NewMessageEvent>.broadcast();
    newConnectionController = 
        new StreamController<NewConnectionEvent>.broadcast();
    _connections = new Map<int, Connection>();
    
    listen_completer = new Completer<String>();
    connection_completer = new Completer<String>();
    
    _log.info("new peer: #${num.toString()} ${this.name} ");
    _loglevel = loglevel;

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
  
  int countConnections([ConnectionState filter=null]){
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
  Stream<NewConnectionEvent> listen(Connection c){
    Future<int> f = c.listen();
    
    //add to list of connections. index is identity of other peer
    //TODO: test if identity is unique
    f.then((int id){
      _connections[id] = c;
      _log.info("new connection added! (now: ${connections.length.toString()})");
      newConnectionController.add(new NewConnectionEvent(c));
      
      //redirect messages
      c.onMessage.listen((NewMessageEvent e){
        
        _log.info("message redirected");
        newMessageController.add(e);
      });
    });
    
    return newConnectionController.stream;
  }
  
  /**
   * connect to another peer
   * 
   * @param Peer other
   */
  Stream<NewConnectionEvent> connect(Connection c){
    Future<int> f = c.connect();
    
    f.then((int id) {
      _connections[id] = c;
      _log.info("new connection added! (now: ${connections.length.toString()})");
      newConnectionController.add(new NewConnectionEvent(c));
      
      //redirect messages
      c.onMessage.listen((NewMessageEvent e){
        
        _log.info("message redirected");
        newMessageController.add(e);
      });
    });
    
    return newConnectionController.stream;
  }
  
  /**
   * send Message to other peer
   * 
   * @param String receiverId receiver of message
   * @param Message msg is content of message
   */
  /**
   * send Message
   * 
   * @ TODO: check if datachannel open. else throw exception
   */
  send(int id, Message msg){
    if(!_connections.containsKey(id))
      throw new StateError("list of connections does not contain peer ${name}");
    
    _connections[id].send(msg);
  }
  
  /**
   * send string to other peer
   */
  sendString(int receiverId, String msg) => send(receiverId, new Message(msg));
  
  /**
   * send message to multiple peers
   */
  broadcast(Iterable<int> receiverIds, Message msg){
    int num = 0;
    
    receiverIds.forEach((int id){
      this.send(id, msg);
      num++;
    });
    
    _log.info("Broadcast: ${num} messages where sent!");
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
   * shutdow specific connection
   */
  disconnect(Connection c){
    //TODO: abort rtc connection
    //close Datachannel
    
    _connections.remove(c);
  }
  
  
  
  /**
   * close all connection
   * 
   * TODO: implementation
   */
  close(){
    
    _connections.forEach((int, Connection c) {
      c.close();
    });
    
    //run garbage collector
    
    _gc();
  }
  
  
  /**
   * garbage collector
   */
  
  _gc(){
    
    List<Connection> garbage = new List<Connection>();
    
    // find closed or undefined connections
    _connections.forEach((int, Connection c){
      if(c.readyState == ConnectionState.CLOSED || c.readyState == ConnectionState.ERROR)
        garbage.add(c);
    });
    
    //remove them
    garbage.forEach((Connection c){
      _connections.remove(c);
    });
    
  }
}