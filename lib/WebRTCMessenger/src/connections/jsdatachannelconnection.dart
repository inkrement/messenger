/**
 * JsDataChannelConnection
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */

part of messenger.connections;

class JsDataChannelConnection extends Connection{
  //map of ice providers
  Map iceServers = {'iceServers':[{'url':'stun:stun.l.google.com:19302'}]};
  
  //peer connection constraints (currently unused)
  var pcConstraint = {};
  
  var mediaConstraints = {};
  
  //RTCDataChannel options
  Map _dcOptions = {};
  
  //JavaScript Proxy of RTCPeerConnection
  js.Proxy _rpc;
  
  //JavaScript Proxy of RTCDataChannel
  js.Proxy _dc;
  
  static final _log = new Logger("messenger.JsDataChannelConnection");
  
  /**
   * constructor
   */
  JsDataChannelConnection(SignalingChannel sc):super(sc), _dc=null{
    _log.finest("created PeerConnection");
    
    /* create RTCPeerConnection */
    if(browser.isChrome)
      _rpc = new js.Proxy(js.context.webkitRTCPeerConnection, js.map(iceServers)); //TODO: add pcConstraints
    else if(browser.isFirefox)
      _rpc = new js.Proxy(js.context.mozRTCPeerConnection, js.map(iceServers)); //TODO: add pcConstraints
    else
      throw new StateError("unsupported browser! please use firefox or chrome");
    
    /*
     * listen for incoming RTCDataChannels
     */
    
    _rpc.ondatachannel = (RtcDataChannelEvent event){
      _log.info("datachannel received");
      
      //set RTCDataChannel
      _dc = (new js.Proxy.fromBrowserObject(event)).channel;
      
      /*
       * set RTCDataChannel callbacks
       */
      
      //onMessage
      _dc.onmessage = (MessageEvent event){
        _log.finest("Message received from DataChannel");
        
        _newMessageController.add(new NewMessageEvent(new Message.fromString(event.data)));
      };
      
      //onOpen
      _dc.onopen = (_){
        _setCommunicationState(new ConnectionState.fromRTCDataChannelState(_dc.readyState));
        _listen_completer.complete(sc.id);
      };
      
      //onClose
      _dc.onclose = (_){
        _setCommunicationState(
            new ConnectionState.fromRTCDataChannelState(_dc.readyState)
            );
      };
      
      //onError TODO: error state!
      _dc.onerror = (x)=>_log.shout("rtc error callback: " + x.toString());
      
      //set state to current DC_State
      _setCommunicationState(new ConnectionState.fromRTCDataChannelState(_dc.readyState));
      
    };
  }
  
  /**
   * gotSignalingMessage callback
   */
  gotSignalingMessage(NewMessageEvent mevent){
    switch(mevent.getMessage().getMessageType()){
      case MessageType.ICE_CANDIDATE:
        _log.finest("got ice candidate");
        
        //deserialize
        var iceCandidate = new js.Proxy(
            js.context.RTCIceCandidate, 
            js.context.JSON.parse(mevent.getMessage().toString())
          );
        
        //add candidate
        _rpc.addIceCandidate(iceCandidate);
        break;
        
      case MessageType.WEBRTC_OFFER:
        _log.fine("received sdp offer");
        
        //deserialize
        var sdp = new js.Proxy(js.context.RTCSessionDescription, js.context.JSON.parse(mevent.getMessage().toString()));
        _rpc.setRemoteDescription(sdp);
        
        createAnswer();
        break;
        
      case MessageType.WEBRTC_ANSWER:
        _log.fine("received sdp answer");

        //deserialize
        var sdp = new js.Proxy(js.context.RTCSessionDescription, js.context.JSON.parse(mevent.getMessage().toString()));
        _rpc.setRemoteDescription(sdp);
        break;
        
      default:
        _log.info("New undefined signaling channel message");
        break;
    }
  }
  
  /**
   * createAnswer
   * 
   * creates new SDP Answer and sends it over signalingChannel
   */
  createAnswer(){
    _rpc.createAnswer((sdp_answer){
      _log.finest("created sdp answer");
      
      _rpc.setLocalDescription(sdp_answer);
      
      //serialize sdp answer
      final String jsonString = js.context.JSON.stringify(sdp_answer);
      
      //send ice candidate to other peer
      _sc.send(new Message(jsonString, MessageType.WEBRTC_ANSWER));
      
      _log.fine("sdp answer sent");
    }, null, mediaConstraints);
  }
  
  /**
   * listen
   * 
   * listen for incoming RTCPeerConnections
   * 
   * @return Future
   */
  Future<int> listen(){
    _log.finest("start listening");
    
    //process all incoming signaling messages
    _sc.onReceive.listen(gotSignalingMessage);
    
    /*
     * New IceCandidate Callback
     */
    _rpc.onicecandidate = (event) {
      _log.finest("new ice candidate received");
      
      //HOTFIX: only add if description set
      //http://stackoverflow.com/questions/17346616
      
     if (!["have-remote-offer", "have-local-pranswer", "have-remote-pranswer"].contains(_rpc.signalingState)){
       _log.warning("ice candidate received before remote description was set");
       return;
     }
       
      
      if(event.candidate != null){
        try{
          var proxy = new js.Proxy.fromBrowserObject(event).candidate;
          
          //serialize ice candidate
          final String jsonString = js.context.JSON.stringify(proxy);
          
          //send ice candidate to other peer
          _sc.send(new Message(jsonString, MessageType.ICE_CANDIDATE));
          
          _log.fine("new ice candidate serialized and sent to other peer");
        } catch(e){
          _log.warning("bob error: could not add ice candidate " + e.toString());
        }
        
      }
        
    }; 
    
    return _listen_completer.future;
  }
  
  /**
   * connect
   * 
   * establish RTCPeerConnection and create RTCDataChannel
   * 
   * @return Future
   */
  Future<int> connect(){
    _log.finest("try to connect");
    
    //listen for incoming connection
    listen();
    
    /*
     * create new RTCDataChannel
     */
    
    try {
      _dc = _rpc.createDataChannel("sendDataChannel", js.map(_dcOptions));
      _log.finest('created new data channel');
      
      /*
       * RTCDataChannel callbacks
       */
      
      //onOpen
      _dc.onopen = (_){
        _setCommunicationState(new ConnectionState.fromRTCDataChannelState(_dc.readyState));
        _connection_completer.complete(_sc.id);
      };
      
      //onClose
      _dc.onclose = (_){
        _log.info("datachannel closed!");
        
        _setCommunicationState(new ConnectionState.fromRTCDataChannelState(_dc.readyState));
      };
      
      //onMessage
      _dc.onmessage = (MessageEvent event){
        _log.finest("Message received from DataChannel");
        
        _newMessageController.add(new NewMessageEvent(new Message.fromString(event.data)));
      };
      
      //TODO: onERROR
      
      /*
       * create SDP OFFER of RTCPeerConnection
       */
      _rpc.createOffer((sdp_offer){
        _log.finest("create sdp offer");
        
        _rpc.setLocalDescription(sdp_offer);
        
        //serialize
        final String jsonString = js.context.JSON.stringify(sdp_offer);
        
        //send serialized string to other peer
        _sc.send(new Message(jsonString, MessageType.WEBRTC_OFFER));
        
      }, (e){
        _connection_completer.completeError(e);
      }, {});

    } catch (e) {
      _connection_completer.completeError("could not complete connect: ${e}");
    }
    
    return _connection_completer.future;
  }
  
  /**
   * init send worker
   * 
   * sends all buffered messages
   */
  _init_send_worker(){
    
    //serialize
    if(_dc == null)
      throw new StateError("could not send message. No DataChannel exists!");
 
    if(this.readyState != ConnectionState.CONNECTED)
      throw new StateError("could not send message. DataChannel is not open!");
    
    _sendController.stream.listen((Message msg){
      _log.info("send message to : ${_sc.id.toString()}");
      
      _dc.send(Message.serialize(msg));
    });
    
  }

  /**
   * shutdown RTCPeerConnection and RTCDataChannel
   * 
   * RTCPeerConnection should close the RTCDataChannel automatically
   * but it's done explicit for clearer structure.
   */
  close(){
    if(_dc != null) _dc.close();
    if(_rpc != null) _rpc.close();
  }
 
  
}