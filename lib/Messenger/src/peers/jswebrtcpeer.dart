part of messenger;

//TODO: support multiconnections
//TODO: signalingchannel

class JsWebRtcPeer extends Peer{
  js.Proxy rtcPeerConnection;
  var dc;
  Map iceServers = {'iceServers':[{'url':'stun:stun.l.google.com:19302'}]};
  var pcConstraint = {};
  Map dataChannelOptions = {};
  
  
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
   * connect to WebrtcPeer
   */
  connect(JsWebRtcPeer o){
    
    /// add ice candidates
    rtcPeerConnection.onicecandidate = (event) {
      
      if(event.candidate != null){
        try{
          o.rtcPeerConnection.addIceCandidate(new js.Proxy.fromBrowserObject(event).candidate);
        } catch(e){
          log.warning("bob error: could not add ice candidate " + e.toString());
        }
      }
        
    };
    
    
    o.rtcPeerConnection.onicecandidate = (event) {
      
      if(event.candidate != null){
        try{
          rtcPeerConnection.addIceCandidate(new js.Proxy.fromBrowserObject(event).candidate);
        } catch(e){
          log.warning("alice error: could not add ice candidate " + e.toString());
        }
      }
    };
    
  /// add Datachannel
    
    try {
      dc = rtcPeerConnection.createDataChannel("sendDataChannel", js.map(dataChannelOptions));
      log.info('Created send data channel');
      
      
      dc.onopen = (_)=>changeReadyState(dc.readyState);
      dc.onclose = (_)=>changeReadyState(dc.readyState);
      
      rtcPeerConnection.createOffer((sdp_alice){
        log.info("create offer");
        
        rtcPeerConnection.setLocalDescription(sdp_alice);
        o.rtcPeerConnection.setRemoteDescription(sdp_alice);
        
        o.rtcPeerConnection.createAnswer((sdp_bob){
          log.info("create answer");
          o.rtcPeerConnection.setLocalDescription(sdp_bob);
          rtcPeerConnection.setRemoteDescription(sdp_bob);
          
          //test datachannel
          //dataChannel.send("test");
        });
      }, (e)=>print(e), {});
      
      
    } catch (e) {
      log.warning("could not create DataChannel: " + e.toString()); 
    }
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