part of messenger;

class JsWebRtcConnection extends Connection{
  js.Proxy _rtcPeerConnection;
  js.Proxy dc;
  
  Map iceServers = {'iceServers':[{'url':'stun:stun.l.google.com:19302'}]};
  var pcConstraint = {};
  Map dataChannelOptions = {};
  
  
  JsWebRtcConnection([Logger logger=null]):super(logger){
    dc=null;
    
    readyStateEvent = new StreamController<ReadyState>.broadcast();
    newMessageController = new StreamController<NewMessageEvent>.broadcast(); 
    
    /* create RTCPeerConnection */
    _rtcPeerConnection = new js.Proxy(js.context.webkitRTCPeerConnection, 
        js.map(iceServers)); //TODO: add pcConstraints
    
    log.fine("created PeerConnection");
    
    _rtcPeerConnection.ondatachannel = (RtcDataChannelEvent event){
      log.info("datachannel received");
      
      var proxy = new js.Proxy.fromBrowserObject(event); 
      
      dc = proxy.channel;
      
      //dc = new js.Proxy(js.context.RTCDataChannel, js.context.JSON.stringify(event.channel));
      /* set channel events */
      dc.onmessage = (MessageEvent event)=>newMessageController.add(new NewMessageEvent(new Message(event.data)));
      
      dc.onopen = (_)=>changeReadyState(new ReadyState.fromDataChannel(dc.readyState));
      dc.onclose = (_)=>changeReadyState(new ReadyState.fromDataChannel(dc.readyState));
      dc.onerror = (x)=>log.shout("rtc error callback: " + x.toString());
  
    
      changeReadyState(new ReadyState.fromDataChannel(dc.readyState));
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
        
        log.fine("connection established");
        connection_completer.complete("wuhuu");
        listen_completer.complete("wuhuu");
        
        //TODO: change status?!
        break;
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
      
      connection_completer.complete(this.hashCode.toString());
      listen_completer.complete(this.hashCode.toString());
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
      dc = _rtcPeerConnection.createDataChannel("sendDataChannel", js.map(dataChannelOptions));
      log.fine('created new data channel');
      
      dc.onopen = (_)=>changeReadyState(new ReadyState.fromDataChannel(dc.readyState));
      dc.onclose = (_)=>changeReadyState(dc.readyState);
      
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

  send(String msg){
    dc.send(msg.toString());
  }
 
  
}