part of messenger;

//TODO: support multiconnections
//TODO: signalingchannel

class JsWebRtcPeer extends Peer{
  var rtcPeerConnection;
  var dataChannel;
  List iceCandidates;
  
  Map iceServers = {
                    'iceServers': [{
                      'url': 'stun:stun.l.google.com:19302'
                    }]
                   };
  var optionalRtpDataChannels = {
                                 "optional": [{
                                   "RtpDataChannels": true
                                 }]
  };
  
  var dataChannelOptions = {'reliable': false} ;
  
  
  
  /**
   * constructor
   */
  JsWebRtcPeer(){
    
    /* init attributes */
    iceCandidates = new List();
    
    /* create RTCPeerConnection */
    rtcPeerConnection = new js.Proxy(js.context.webkitRTCPeerConnection, 
        js.map(iceServers), js.map(optionalRtpDataChannels));
    
    rtcPeerConnection.onIceCandidate = (event){
      if(event.candidate)
        iceCandidates.add(event.candidate);
    };
    
    rtcPeerConnection.onDataChannel = (event){
      print("got datachannel");
      
      dataChannel = event.channel;
      dataChannel.onmessage = (data)=>print(data);
    };
  }
  
  
  
  /**
   * connect to WebrtcPeer
   */
  connect(JsWebRtcPeer o){
    
    /* TODO: send Ice candidate to other peer */
    
    iceCandidates.forEach((elem){
      o.rtcPeerConnection.addIceCandidate(elem, ()=>print("ok"),(var error) => print("faaail"));
    });
      
    
    /* create DataChannel */
    dataChannel = rtcPeerConnection.createDataChannel('RTCDataChannel',
       js.map(dataChannelOptions));
    
    
    /* set channel events */
    dataChannel.onmessage = (x)=>print("rtc message callback: " + x);
    dataChannel.onopen = (x)=>print("rtc open callback");
    dataChannel.onclose = (x)=>print("rtc close callback");
    dataChannel.onerror = (x)=>print("rtc error callback");
    
    rtcPeerConnection.createOffer((sdp_alice){
      print("alice created offer");
      
      rtcPeerConnection.setLocalDescription(sdp_alice);
      o.rtcPeerConnection.setRemoteDescription(sdp_alice);
      
      o.rtcPeerConnection.createAnswer((sdp_bob){
        o.rtcPeerConnection.setLocalDescription(sdp_bob);
        rtcPeerConnection.setRemoteDescription(sdp_bob);
      });
    }, (e)=>print(e), {});
    
    //add to the peers
    _connections.add(o);
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