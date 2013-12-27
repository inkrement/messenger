part of messenger;

//TODO: support multiconnections
//TODO: signalingchannel

class JsWebRtcPeer extends Peer{
  var rtcPeerConnection;
  var dataChannel;
  
  
  Map iceServers = {
                    'iceServers': [{
                      'url': 'stun:stun.l.google.com:19302'
                    }]
                   };
  var pcConstraint = {};
  
 // var dataChannelOptions = [];
  
  /* Future to handle async event */
  StreamController readyStateEvent;
  String readyState;
  
  /**
   * constructor
   */
  JsWebRtcPeer():readyState="none"{
    log.info("started new JsWebRtcPeer!");
    
    /* init attributes */
    readyStateEvent = new StreamController.broadcast();
    
    /* create RTCPeerConnection */
    rtcPeerConnection = new js.Proxy(js.context.webkitRTCPeerConnection, 
        js.map(iceServers)); //TODO: add pcConstraints
    
    log.fine("created PeerConnection");
    
    rtcPeerConnection.onDataChannel = (event){
      log.fine("datachannel received");
      
      dataChannel = event.channel;
      /* set channel events */
      dataChannel.onmessage = (x)=>print("rtc message callback: " + x);
      
      dataChannel.onopen = (x)=>changeReadyState(dataChannel.readyState);
      dataChannel.onclose = (x)=>changeReadyState(dataChannel.readyState);
      //dataChannel.onerror = (x)=>print("rtc error callback");
      
      readyState = dataChannel.readyState;
    };
  }
  
  
  //make private
  changeReadyState(String readyState){
    log.info("change state: " + readyState);
    
    this.readyState = readyState;
    readyStateEvent.add(readyState);
  }
  
  
  /**
   * connect to WebrtcPeer
   */
  connect(JsWebRtcPeer o){
    log.info("try to connect to :");
    
    /* create DataChannel */
    dataChannel = rtcPeerConnection.createDataChannel('RTCDataChannel',
       null); //js.map(dataChannelOptions)
    
    /* handle ice candidates */
    rtcPeerConnection.onIceCandidate = (event){
      log.fine("new ice candidate!");
      //TODO: yeees received ICE candidate
      //gotIceCandidate.complete();
      
      //throw new StateError("ice candidate");
      
      if(event.candidate)
        o.rtcPeerConnection.addIceCandiate(event.candidate);
    };
    
    o.rtcPeerConnection.onIceCandidate = (event){
      log.fine("new ice candidate!");

      if(event.candidate)
        rtcPeerConnection.addIceCandiate(event.candidate);
    };
    
    /* TODO: send Ice candidate to other peer */
    
    /*iceCandidates.forEach((elem){
      o.rtcPeerConnection.addIceCandidate(elem, ()=>print("ok"),(var error) => print("faaail"));
    });*/
     
    
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
    
    
    //add to the peers
    _connections.add(o);
    
    //return gotIceCandidate.future;
  }
  
  
  
  /**
   * disconnect Peer
   */
  disconnect(JsWebRtcPeer o){
    //TODO: abort rtc connection
    
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
    dataChannel.send(msg.toString());
  }
  
}