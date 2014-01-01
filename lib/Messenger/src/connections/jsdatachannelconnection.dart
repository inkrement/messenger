/**
 * class JsDataChannelConnection
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */


part of messenger.connections;

class JsDataChannelConnection extends Connection{
  js.Proxy _rtcPeerConnection;
  js.Proxy _dc;
  
  Map iceServers = {'iceServers':[{'url':'stun:stun.l.google.com:19302'}]};
  var pcConstraint = {};
  Map dataChannelOptions = {};
  
  
  JsDataChannelConnection(SignalingChannel sc, Logger log):super(sc, log){
    _log.fine("created PeerConnection");
    _dc=null;
    
    /* create RTCPeerConnection */
    _rtcPeerConnection = new js.Proxy(js.context.webkitRTCPeerConnection, 
        js.map(iceServers)); //TODO: add pcConstraints
    
    _rtcPeerConnection.ondatachannel = (RtcDataChannelEvent event){
      _log.info("datachannel received");
      
      var proxy = new js.Proxy.fromBrowserObject(event); 
      _dc = proxy.channel;
      
      /* set channel events */
      _dc.onmessage = (MessageEvent event){
        _log.finest("Message received from DataChannel");
        
        newMessageController.add(new NewMessageEvent(new Message.fromString(event.data)));
      };
      
      _dc.onopen = (_){
        changeReadyState(new ReadyState.fromDataChannel(_dc.readyState));
        _listen_completer.complete(sc.id);
      };
      
      _dc.onclose = (_)=>changeReadyState(new ReadyState.fromDataChannel(_dc.readyState));
      _dc.onerror = (x)=>_log.shout("rtc error callback: " + x.toString());
      
      //set state to current DC_State
      changeReadyState(new ReadyState.fromDataChannel(_dc.readyState));
    };
  }
  
  /**
   * gotSignalingMessage callback
   */
  gotSignalingMessage(NewMessageEvent mevent){
    switch(mevent.getMessage().getMessageType()){
      case MessageType.ICE_CANDIDATE:
        //log.info("got ice candidate");
        
        //deserialize
        var iceCandidate = new js.Proxy(js.context.RTCIceCandidate, js.context.JSON.parse(mevent.getMessage().toString()));
        
        //add candidate
        _rtcPeerConnection.addIceCandidate(iceCandidate);
        break;
      case MessageType.STRING:
        //new Message. pass it!
        break;
        
        /**
         * TODO: change peer_id and akn_peer_id to syn and akn or use it for key exchange
         */
      case MessageType.PEER_ID:
        _log.fine("PEER_ID received: connection established");
        //listen_completer.complete(sc.id);
        
        _sc.send(new Message(this.hashCode.toString(), MessageType.AKN_PEER_ID));
        changeReadyState(ReadyState.CONNECTED);
        
        break;
      case MessageType.AKN_PEER_ID:
        _log.fine("AKN_PEER_ID received:  connection established");
        
        break;
      case MessageType.WEBRTC_OFFER:
        _log.fine("received sdp offer");
        
        //deserialize
        var sdp = new js.Proxy(js.context.RTCSessionDescription, js.context.JSON.parse(mevent.getMessage().toString()));
        
        _rtcPeerConnection.setRemoteDescription(sdp);
        
        createAnswer();
        break;
        
      case MessageType.WEBRTC_ANSWER:
        _log.fine("received sdp answer");
        
        //deserialize
        var sdp = new js.Proxy(js.context.RTCSessionDescription, js.context.JSON.parse(mevent.getMessage().toString()));

        _rtcPeerConnection.setRemoteDescription(sdp);
        
        //send if open
        readyStateEvent.stream.listen((ReadyState rs){
          if (rs == ReadyState.DC_OPEN){
            _log.info("send PEER_ID");
            _sc.send(new Message(this.hashCode.toString(), MessageType.PEER_ID));
          }
        });
        
    }
  }
  
  /**
   * RTC SDP answer
   */
  createAnswer(){
    _rtcPeerConnection.createAnswer((sdp_answer){
      _log.fine("created sdp answer");
      
      _rtcPeerConnection.setLocalDescription(sdp_answer);
      
      //serialize sdp answer
      final String jsonString = js.context.JSON.stringify(sdp_answer);
      
      //send ice candidate to other peer
      _sc.send(new Message(jsonString, MessageType.WEBRTC_ANSWER));
      _log.fine("sdp answer sent");
    });
  }
  
  /**
   * listen for incoming connections
   */
  Future<int> listen(){
    _log.finest("start listening");
    
    _sc.onReceive.listen(gotSignalingMessage);
    
    /// add ice candidates
    
    _rtcPeerConnection.onicecandidate = (event) {
      _log.finest("new ice candidate received");
      
      if(event.candidate != null){
        try{
          var proxy = new js.Proxy.fromBrowserObject(event).candidate;
          
          //serialize ice candidate
          final String jsonString = js.context.JSON.stringify(proxy);
          
          //send ice candidate to other peer
          _sc.send(new Message(jsonString, MessageType.ICE_CANDIDATE));
          
          _log.finest("new ice candidate serialized and sent to other peer");
        } catch(e){
          _log.warning("bob error: could not add ice candidate " + e.toString());
        }
      }
        
    }; 
    
    return _listen_completer.future;
  }
  
  /**
   * connect to WebrtcPeer
   */
  Future<int> connect(){
    _log.finest("try to connect");
    
    //listen for incoming connection
    listen();
    
    /// create datachannel
    
    try {
      _dc = _rtcPeerConnection.createDataChannel("sendDataChannel", js.map(dataChannelOptions));
      _log.fine('created new data channel');
      
      _dc.onopen = (_){
        changeReadyState(new ReadyState.fromDataChannel(_dc.readyState));
        _connection_completer.complete(_sc.id);
        
        changeReadyState(ReadyState.CONNECTED);
      };
      _dc.onclose = (_)=>changeReadyState(_dc.readyState);
      
      _dc.onmessage = (MessageEvent event){
        _log.finest("Message received from DataChannel");
        
        newMessageController.add(new NewMessageEvent(new Message.fromString(event.data)));
      };
      
      _rtcPeerConnection.createOffer((sdp_offer){
        _log.fine("create sdp offer");
        
        _rtcPeerConnection.setLocalDescription(sdp_offer);
        
        //serialize
        final String jsonString = js.context.JSON.stringify(sdp_offer);
        
        _sc.send(new Message(jsonString, MessageType.WEBRTC_OFFER));
        
      }, (e){
        _connection_completer.completeError(e, e.stackTrace);
      }, {});

    } catch (e) {
      _connection_completer.completeError("could not complete connect: ${e}", e.stackTrace);
    }
    
    //return completer
    return _connection_completer.future;
  }

  send(Message msg){
    //serialize
    if(_dc == null){
      _log.warning("could not send message. No DataChannel open!");
      return;
    }
    
    //TODO: not ready, pipe message.
    _log.info("send message to : ${_sc.id.toString()}");
    _dc.send(Message.serialize(msg));
  }
 
  
}