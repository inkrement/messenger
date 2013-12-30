part of messenger;

class JsWebRtcPeer extends Peer{
  js.Proxy rtcPeerConnection;
  js.Proxy dc;
  Map iceServers = {'iceServers':[{'url':'stun:stun.l.google.com:19302'}]};
  var pcConstraint = {};
  Map dataChannelOptions = {};
  
  //TODO: what if not set yet.
  SignalingChannel sc;
  
  
  /**
   * constructor
   */
  JsWebRtcPeer([String name="", Level logLevel=Level.FINE]):super(name, logLevel){  
    dc = null;
    
    /* create RTCPeerConnection */
    rtcPeerConnection = new js.Proxy(js.context.webkitRTCPeerConnection, 
        js.map(iceServers)); //TODO: add pcConstraints
    
    log.fine("created PeerConnection");
    
    rtcPeerConnection.ondatachannel = (RtcDataChannelEvent event){
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
        rtcPeerConnection.addIceCandidate(iceCandidate);
        break;
      case MessageType.STRING:
        //new Message. pass it!
        break;
      case MessageType.WEBRTC_OFFER:
        log.fine("received sdp offer");
        
        //deserialize
        var sdp = new js.Proxy(js.context.RTCSessionDescription, js.context.JSON.parse(data.data.msg));
        
        rtcPeerConnection.setRemoteDescription(sdp);
        
        createAnswer();
        break;
        
      case MessageType.WEBRTC_ANSWER:
        log.fine("received sdp answer");
        
        //deserialize
        var sdp = new js.Proxy(js.context.RTCSessionDescription, js.context.JSON.parse(data.data.msg));

        rtcPeerConnection.setRemoteDescription(sdp);
        
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
    rtcPeerConnection.createAnswer((sdp_answer){
      log.fine("created sdp answer");
      
      rtcPeerConnection.setLocalDescription(sdp_answer);
      
      //serialize sdp answer
      final String jsonString = js.context.JSON.stringify(sdp_answer);
      
      //send ice candidate to other peer
      sc.send(new Message(jsonString, MessageType.WEBRTC_ANSWER));
      log.fine("sdp answer sent");
      
      connection_completer.complete("wuhuu");
      listen_completer.complete("wuhuu");
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
    
    rtcPeerConnection.onicecandidate = (event) {
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
      dc = rtcPeerConnection.createDataChannel("sendDataChannel", js.map(dataChannelOptions));
      log.fine('created new data channel');
      
      dc.onopen = (_)=>changeReadyState(new ReadyState.fromDataChannel(dc.readyState));
      dc.onclose = (_)=>changeReadyState(dc.readyState);
      
      rtcPeerConnection.createOffer((sdp_offer){
        log.fine("create sdp offer");
        
        rtcPeerConnection.setLocalDescription(sdp_offer);
        
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
  
  
  
  /**
   * disconnect Peer
   */
  disconnect(JsWebRtcPeer o){
    //TODO: abort rtc connection
    //close Datachannel
    
    _connections.remove(o);
  }
  
  
  
  /**
   * close Connection
   * 
   * TODO: implementation
   */
  close(){}
  
  
  
  /**
   * send Message
   * 
   * @ TODO: check if datachannel open. else throw exception
   */
  send(JsWebRtcPeer o, Message msg){
    log.info("send message!");
    dc.send(msg.toString());
  }
  
}