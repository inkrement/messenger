/**
 * ChromeAppTCPSignaling
 * 
 * simple example for a bidirectional signaling channel based on some undefined js technology
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */

part of messenger.signaling;

class ChromeAppTCPSignaling extends SignalingChannel{
  static final String TAG = 'ChromeAppTCPSignaling';
  static final Logger _log = new Logger("ChromeAppTCPSignaling");
  int start_port = 8543;
  int max_attempts = 10;
  int socketId;
  int connection_socket_id = -1;
  int c_port;
  String c_host="127.0.0.1";
  String l_host="127.0.0.1";
  TcpClient client = null;
  
  ChromeAppTCPSignaling(){
    _log.finest('instantiate new ChromeAppTCPSignaling object');
    
    //test if api available
    if (!sockets.tcpServer.available)
      throw new ChromeApiNotAvailable('chrome socket API not available');
        
    
    
    TcpServer.createServerSocket(37123).then((TcpServer s) {
      s.onAccept.listen((TcpClient c){
        c.stream.listen((List<int> data){
          client = c;
          
          MessengerMessage msg = new MessengerMessage(UTF8.decode(data), MessageType.SIGNAL);
          newMessageController.add(new NewMessageEvent(msg));
          
          sendString("received something. thx");
          
        });
      });
      
    });
  }
  
  /*
  Future<int> _listen(int port){
    final c = new Completer<int>();
    
    //limit listen retries
    if ( max_attempts + start_port <= port){
        c.complete();
        throw new TooManyConnectionAttempts('could not listen. too many unsuccessful attempts');
    }
    
    sockets.tcpServer.listen(socketId, l_host, port).then((int result){
      if (result < 0){
        //some error occurred
        
        //try next port.
        _listen(port + 1).then((int result){
          _log.info('try to listen on the next port');
          c.complete(result);
        });
        
      }else{
        _log.info('now listening on port ' + port.toString());
        c.complete(port);
      }
    }).catchError((e){
      
      _log.warning('could not listen on port ' + port.toString() + ': ' + e.toString() );
      //try next port.
      _listen(port + 1).then((int result){
        _log.info('try to listen on the next port');
        c.complete(result);
      });
    });
    
      
    return c.future;
  }
  */
  
  
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
    
    if(connection_socket_id != -1)
      throw new BadConnectionState('socket already connected!');
    
    
    _log.info('connect to ' + c_host + ' ' + c_port.toString());
    
    sockets.tcp.create().then((CreateInfo info){
      connection_socket_id = info.socketId;
      
      sockets.tcp.connect(connection_socket_id, c_host, c_port.toInt()).then((int result){
        
      });
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
    connection_completer.complete("connection closed");
  }

  
}
