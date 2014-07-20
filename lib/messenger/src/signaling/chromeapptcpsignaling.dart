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
  int connection_socket = -1;
  int c_port;
  String c_host="127.0.0.1";
  String l_host="127.0.0.1";
  
  ChromeAppTCPSignaling(){
    _log.finest('instantiate new ChromeAppTCPSignaling object');
    
    //test if api available
    if (!sockets.tcpServer.available)
      throw new ChromeApiNotAvailable('chrome socket API not available');
    
    //set onreceive handler
    _log.finest('setup tcp onreceive handler');
    
    sockets.tcp.onReceive.listen((ReceiveInfo info){
      String msg = info.data.toString();
      
      _log.finest('new message received! (' + msg + ')');
      
      newMessageController.add(new NewMessageEvent(new MessengerMessage(msg)));
    });
    
    sockets.tcpServer.create().then((CreateInfo info){
      _log.finest('new TCP Socket created');
      
      socketId = info.socketId;
      
      _listen(start_port).then((int result){
        
        _log.finest("start accepting new connections... ");
        
        sockets.tcpServer.onAccept.listen((AcceptInfo info){
          _log.fine('new incoming connection started!');
          
          connection_socket = info.socketId;
        
        });
        
      });
      
    });
    
  }
  
  
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
  
  
  
  
  void _connection_established(){
    
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
    
    if(connection_socket != -1)
      throw new BadConnectionState('socket already connected!');
    
    
    _log.info('connect to ' + c_host + ' ' + c_port.toString());
    
    sockets.tcp.create().then((CreateInfo info){
      connection_socket = info.socketId;
      
      sockets.tcp.connect(connection_socket, c_host, c_port.toInt()).then((int result){
        
      });
    });
  }
  
  /**
   * send message
   * 
   * TODO: test if function exists
   */
  send(MessengerMessage message) {
    if(connection_socket == -1)
      throw new NotConnected('No valid socket available');
   
      
    sockets.tcp.send(connection_socket, 
        new ArrayBuffer.fromBytes(UTF8.encode(
            MessengerMessage.serialize(message)
        ))
    );
  }
  
  /**
   * close
   */
  close(){
    connection_completer.complete("connection closed");
  }

  
}