part of messenger;

//TODO: support multiconnections
//TODO: signalingchannel

class JsWebRtcPeer extends Peer{
  js.Proxy rtcPeerConnection;
  var dc;
  Map iceServers = {'iceServers':[{'url':'stun:stun.l.google.com:19302'}]};
  var pcConstraint = {};
  Map dataChannelOptions = {};
  
  //TODO: what if not set yet.
  SignalingChannel sc;
  
  
  /**
   * constructor
   */
  JsWebRtcPeer([String name=""]){
    
    /* init attributes */
    readyStateEvent = new StreamController.broadcast();
    
    /* create RTCPeerConnection */
    rtcPeerConnection = new js.Proxy(js.context.webkitRTCPeerConnection, 
        js.map(iceServers)); //TODO: add pcConstraints
    
    //log.fine("created PeerConnection");
    
    rtcPeerConnection.onDataChannel = (event){
      log.fine("datachannel received");
      
      dc = event.channel;
      /* set channel events */
      dc.onmessage = (x)=>print("rtc message callback: " + x);
      
      dc.onopen = (_)=>changeReadyState(dc.readyState);
      dc.onclose = (_)=>changeReadyState(dc.readyState);
      dc.onerror = (x)=>print("rtc error callback: " + x.toString());
      
      readyState = dc.readyState;
    };
  }
  
  /**
   * gotSignalingMessage callback
   */
  gotSignalingMessage(NewMessageEvent data){
    switch(data.data.mtype){
      case MessageType.ICE_CANDIDATE:
        log.info("got ice candidate");
        //add ice candaidate
        break;
      case MessageType.STRING:
        //new Message. pass it!
        break;
      case MessageType.WEBRTC_OFFER:
        log.info("got offer: " + data.data.msg);
        createAnswer();
        break;
    }
  }
  
  /**
   * RTC SDP answer
   */
  createAnswer(){
    rtcPeerConnection.createAnswer((sdp_answer){
      log.info("create answer");
      
      rtcPeerConnection.setLocalDescription(sdp_answer);
      sc.send(new Message(sdp_answer.toJs(), MessageType.WEBRTC_ANSWER));
      
      connection_completer.complete("wuhuu");
    });
  }
  
  /**
   * connect to WebrtcPeer
   */
  Future connect(SignalingChannel sc){
    
    this.sc = sc;
    
    sc.onReceive.listen(gotSignalingMessage);
    
    /// add ice candidates
    rtcPeerConnection.onicecandidate = (event) {
      
      if(event.candidate != null){
        try{
          
          (new js.Proxy.fromBrowserObject(event).candidate);
          
          //log.info((new js.Proxy.fromBrowserObject(event).candidate).toJs());
          sc.send(new Message(JSON.encode(new js.Proxy.fromBrowserObject(event).candidate), MessageType.ICE_CANDIDATE));
          
          //new js.Proxy.fromBrowserObject(event).toJs();
          
          //o.rtcPeerConnection.addIceCandidate();
        } catch(e){
          log.warning("bob error: could not add ice candidate " + e.toString());
        }
      }
        
    };
    
  /// create datachannel
    
    try {
      dc = rtcPeerConnection.createDataChannel("sendDataChannel", js.map(dataChannelOptions));
      log.info('Created send data channel');
      
      
      dc.onopen = (_)=>changeReadyState(dc.readyState);
      dc.onclose = (_)=>changeReadyState(dc.readyState);
      
      rtcPeerConnection.createOffer((sdp_offer){
        log.info("create offer");
        
        rtcPeerConnection.setLocalDescription(sdp_offer);
        sc.send(new Message(sdp_offer.toString(), MessageType.WEBRTC_OFFER));
        
        //TODO: send offer
        //rtcPeerConnection.setRemoteDescription(sdp_alice);
        
        
      }, (e){
        connection_completer.completeError(e, e.stackTrace);
      }, {});

    } catch (e) {
      connection_completer.completeError(e, e.stackTrace);
    }
    
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
   */
  send(JsWebRtcPeer o, Message msg){
    dc.send(msg.toString());
  }
  
}