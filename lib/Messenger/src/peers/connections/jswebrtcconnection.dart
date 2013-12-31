part of messenger;

class JsWebRtcConnection extends Connection{
  js.Proxy _rtcPeerConnection;
  js.Proxy _dc;
  
  Map iceServers = {'iceServers':[{'url':'stun:stun.l.google.com:19302'}]};
  var pcConstraint = {};
  Map dataChannelOptions = {};
  
  
  JsWebRtcConnection([Logger logger=null]):super(logger){
    _dc=null;
    
    readyStateEvent = new StreamController<ReadyState>.broadcast();
    newMessageController = new StreamController<NewMessageEvent>.broadcast(); 
    
    /* create RTCPeerConnection */
    _rtcPeerConnection = new js.Proxy(js.context.webkitRTCPeerConnection, 
        js.map(iceServers)); //TODO: add pcConstraints
    
    log.fine("created PeerConnection");
    
    _rtcPeerConnection.ondatachannel = (RtcDataChannelEvent event){
      log.info("datachannel received");
      
      var proxy = new js.Proxy.fromBrowserObject(event); 
      
      _dc = proxy.channel;
      
      //dc = new js.Proxy(js.context.RTCDataChannel, js.context.JSON.stringify(event.channel));
      /* set channel events */
      _dc.onmessage = (MessageEvent event)=>newMessageController.add(new NewMessageEvent(new Message.fromString(event.data)));
      
      _dc.onopen = (_)=>changeReadyState(new ReadyState.fromDataChannel(_dc.readyState));
      _dc.onclose = (_)=>changeReadyState(new ReadyState.fromDataChannel(_dc.readyState));
      _dc.onerror = (x)=>log.shout("rtc error callback: " + x.toString());
  
    
      changeReadyState(new ReadyState.fromDataChannel(_dc.readyState));
    };
  }
  
  /**
   * gotSignalingMessage callback
   */
  gotSignalingMessage(NewMessageEvent data){
    switch(data.data.mtype){
      case MessageType.ICE_CANDIDATE:
        //log.info("got ice candidate");
        
        //deserialize
        var iceCandidate = new js.Proxy(js.context.RTCIceCandidate, js.context.JSON.parse(data.data.msg));
        
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
        log.fine("PEER_ID received: connection established");
        listen_completer.complete(sc.id.toString());
        
        sc.send(new Message(this.hashCode.toString(), MessageType.AKN_PEER_ID));
        changeReadyState(ReadyState.CONNECTED);
        
        break;
      case MessageType.AKN_PEER_ID:
        log.fine("AKN_PEER_ID received:  connection established");
        connection_completer.complete(sc.id.toString());
        
        changeReadyState(ReadyState.CONNECTED);
        break;
      case MessageType.WEBRTC_OFFER:
        log.fine("received sdp offer");
        
        //deserialize
        var sdp = new js.Proxy(js.context.RTCSessionDescription, js.context.JSON.parse(data.data.msg));
        
        _rtcPeerConnection.setRemoteDescription(sdp);
        
        createAnswer();
        break;
        
      case MessageType.WEBRTC_ANSWER:
        log.fine("received sdp answer");
        
        //deserialize
        var sdp = new js.Proxy(js.context.RTCSessionDescription, js.context.JSON.parse(data.data.msg));

        _rtcPeerConnection.setRemoteDescription(sdp);
        
        //send if open
        readyStateEvent.stream.listen((ReadyState rs){
          if (rs == ReadyState.DC_OPEN){
            log.info("send PEER_ID");
            sc.send(new Message(this.hashCode.toString(), MessageType.PEER_ID));
          }
        });
        
    }
  }
  
  /**
   * RTC SDP answer
   */
  createAnswer(){
    _rtcPeerConnection.createAnswer((sdp_answer){
      log.fine("created sdp answer");
      
      _rtcPeerConnection.setLocalDescription(sdp_answer);
      
      //serialize sdp answer
      final String jsonString = js.context.JSON.stringify(sdp_answer);
      
      //send ice candidate to other peer
      sc.send(new Message(jsonString, MessageType.WEBRTC_ANSWER));
      log.fine("sdp answer sent");
    });
  }
  
  /**
   * listen for incoming connections
   */
  Future listen(SignalingChannel sc){
    log.finest("start listening");
    
    this.sc = sc;
    
    sc.onReceive.listen(gotSignalingMessage);
    
    /// add ice candidates
    
    _rtcPeerConnection.onicecandidate = (event) {
      log.finest("new ice candidate received");
      
      if(event.candidate != null){
        try{
          var proxy = new js.Proxy.fromBrowserObject(event).candidate;
          
          //serialize ice candidate
          final String jsonString = js.context.JSON.stringify(proxy);
          
          //send ice candidate to other peer
          sc.send(new Message(jsonString, MessageType.ICE_CANDIDATE));
          
          log.finest("new ice candidate serialized and sent to other peer");
        } catch(e){
          log.warning("bob error: could not add ice candidate " + e.toString());
        }
      }
        
    }; 
    
    return listen_completer.future;
  }
  
  /**
   * connect to WebrtcPeer
   */
  Future connect(SignalingChannel sc){
    log.finest("try to connect");
    
    //listen for incoming connection
    listen(sc);
    
    /// create datachannel
    
    try {
      _dc = _rtcPeerConnection.createDataChannel("sendDataChannel", js.map(dataChannelOptions));
      log.fine('created new data channel');
      
      _dc.onopen = (_)=>changeReadyState(new ReadyState.fromDataChannel(_dc.readyState));
      _dc.onclose = (_)=>changeReadyState(_dc.readyState);
      
      _dc.onmessage = (MessageEvent event)=>newMessageController.add(new NewMessageEvent(new Message.fromString(event.data)));
      
      _rtcPeerConnection.createOffer((sdp_offer){
        log.fine("create sdp offer");
        
        _rtcPeerConnection.setLocalDescription(sdp_offer);
        
        //serialize
        final String jsonString = js.context.JSON.stringify(sdp_offer);
        
        sc.send(new Message(jsonString, MessageType.WEBRTC_OFFER));
        
      }, (e){
        connection_completer.completeError(e, e.stackTrace);
      }, {});

    } catch (e) {
      connection_completer.completeError("could not complete connect: ${e}", e.stackTrace);
    }
    
    //return completer
    return connection_completer.future;
  }

  send(Message msg){
    //serialize
    _dc.send(Message.serialize(msg));
  }
 
  
}