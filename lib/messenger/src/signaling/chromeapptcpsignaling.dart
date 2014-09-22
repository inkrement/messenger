/**
 * ChromeAppTCPSignaling
 * 
 * simple example for a bidirectional signaling channel based on some undefined js technology
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */

part of messenger.signaling;

class ChromeAppTCPSignaling extends SignalingChannel{
  static final Logger _log = new Logger("messenger.signaling.ChromeAppTCPSignaling");
  int start_port = 8543;
  int max_attempts = 10;
  int socketId;
  int connection_socket_id = -1;
  int c_port;
  String c_host="127.0.0.1";
  String l_host="127.0.0.1";
  TcpClient client = null;
  
  ChromeAppTCPSignaling(int port){
    _log.finest('instantiate new ChromeAppTCPSignaling object');
    
    //test if api available
    if (!sockets.tcpServer.available)
      throw new ChromeApiNotAvailable('chrome socket API not available');
    
    c_port = port;
        
    newEventsController.add(SignalingChannelEvents.CREATED);
    
    TcpServer.createServerSocket(port).then((TcpServer s) {
      
      newEventsController.add(SignalingChannelEvents.LISTENING);
      
      s.onAccept.listen((TcpClient c){
        _log.fine("listen for incoming connections");
        client = c;
        
        newEventsController.add(SignalingChannelEvents.NEW_INCOMING_CONNECTION);
        
        c.stream.listen((List<int> data){
          
          MessengerMessage msg = MessengerMessage.fromString(UTF8.decode(data));
          _log.info("new Signaling Message: " + msg.toString());
          newMessageController.add(new NewMessageEvent(msg));
          
        });
      });
      
    });
  }
  
  
  /**
   * connect
   * 
   * @ TODO: add custom Exceptions
   *  * prevent self-connections
   */
  void connect(Map options){
    
    if(options.containsKey("host"))
      c_host = options["host"];
    
    if(!options.containsKey("port"))
        throw new BadConfiguration('TCPSignaling channel needs a port configuration');
    
    c_port = int.parse(options["port"]);
    
    if(client != null) client.dispose();
    
    
    _log.info('connect to ' + c_host + ' ' + c_port.toString());
    
    
    
    TcpClient.createClient(c_host, c_port).then((TcpClient c) {
      newEventsController.add(SignalingChannelEvents.NEW_OUTGOING_CONNECTION);
      
        client = c;
        
        c.stream.listen((List<int> data){
          
          MessengerMessage msg = MessengerMessage.fromString(UTF8.decode(data));
          _log.info("new Signaling Message: " + msg.toString());
          newMessageController.add(new NewMessageEvent(msg));
          
        });
      }).catchError((var error){
        _log.warning(error.toString());
        newEventsController.add(SignalingChannelEvents.NOT_ABLE_TO_LISTEN);
    });
  }
  
  /**
   * send message
   * 
   * TODO: test if function exists
   */
  void send(MessengerMessage message) {
    sendString(MessengerMessage.serialize(message));
  }
  
  
  void sendString(String str){
    if(client == null)
      throw new NotConnected('No valid socket available');
    
    client.writeString(str);
  }
  
  /**
   * close
   */
  close(){
    if (client != null) client.dispose();
    
    connection_completer.complete("connection closed");
  }

  
}
