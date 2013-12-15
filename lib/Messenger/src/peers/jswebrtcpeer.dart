part of messenger;

//TODO: support multiconnections
class JsWebRtcPeer extends Peer{
  var rtcPeerConnection;
  var dataChannel;
  
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
  
  JsWebRtcPeer(){
    
    /* create RTCPeerConnection */
    rtcPeerConnection = new js.Proxy(js.context.webkitRTCPeerConnection, 
        new js.Serializable(iceServers)); // TODO: add optionalRtpDataChannels
    
    /* create DataChannel */
    /*
    rtcPeerConnection.callMethod('createDataChannel', ['RTCDataChannel', {
      'reliable': false
    } ]);
    */
    
    /* set channel events */
    /*
    dataChannel = rtcPeerConnection.callMethod('createDataChannel', []);
    
    js.context.onmessagecallback = (x)=>print("rtc message callback: " + x);
    js.context.onopencallback = (x)=>print("rtc open callback");
    js.context.onclosecallback = (x)=>print("rtc close callback");
    js.context.onerrorcallback = (x)=>print("rtc error callback");
    
    dataChannel.callMethod('onmessage', ['onmessagecallback']);
    dataChannel.callMethod('onopen', ['onopencallback']);
    dataChannel.callMethod('onclose', ['onclosecallback']);
    dataChannel.callMethod('onerror', ['onerrorcallback']);
    */
  }
  
  
  
  
  /**
   * connect to WebrtcPeer
   */
  connect(JsWebRtcPeer o){
    
    /* ice candidate callback */
    
    js.context.onicecandidatecallback = (e){
      if (!e || !e.candidate) return;
         o.rtcPeerConnection.addIceCandidate(e.candidate);
    };
    rtcPeerConnection.callMethod('onicecandidate', []);
    
    /* create offer */
    this.rtcPeerConnection.callMethod('createOffer', [(sessionDescription){
      rtcPeerConnection.callMethod('setLocalDescription', [sessionDescription]);
      
      /* create answer */
      
      
      //TODO
      
    }, null, []]);
    
    
    //add to the peers
    _connections.add(o);
  }
  
  disconnect(JsWebRtcPeer o){
    
    //TODO: abort rtc connection
    
    _connections.remove(o);
  }
  
  close(){
    
  }
  
  send(JsWebRtcPeer o, Message msg){
    dataChannel.callMethod('send', [msg.toString()]);
  }
  
  /*
   * var iceServers = {
    iceServers: [{
        url: 'stun:stun.l.google.com:19302'
    }]
};

var optionalRtpDataChannels = {
    optional: [{
        RtpDataChannels: true
    }]
};

var offerer = new webkitRTCPeerConnection(iceServers, optionalRtpDataChannels),
    answerer, answererDataChannel;

var offererDataChannel = offerer.createDataChannel('RTCDataChannel', {
    reliable: false
});
setChannelEvents(offererDataChannel, 'offerer');

offerer.onicecandidate = function (event) {
    if (!event || !event.candidate) return;
    answerer && answerer.addIceCandidate(event.candidate);
};

var mediaConstraints = {
    optional: [],
    mandatory: {
        OfferToReceiveAudio: false, // Hmm!!
        OfferToReceiveVideo: false // Hmm!!
    }
};

offerer.createOffer(function (sessionDescription) {
    offerer.setLocalDescription(sessionDescription);
    createAnswer(sessionDescription);
}, null, mediaConstraints);


function createAnswer(offerSDP) {
    answerer = new webkitRTCPeerConnection(iceServers, optionalRtpDataChannels);
    answererDataChannel = answerer.createDataChannel('RTCDataChannel', {
        reliable: false
    });

    setChannelEvents(answererDataChannel, 'answerer');

    answerer.onicecandidate = function (event) {
        if (!event || !event.candidate) return;
        offerer && offerer.addIceCandidate(event.candidate);
    };

    answerer.setRemoteDescription(offerSDP);
    answerer.createAnswer(function (sessionDescription) {
        answerer.setLocalDescription(sessionDescription);
        offerer.setRemoteDescription(sessionDescription);
    }, null, mediaConstraints);
}

function setChannelEvents(channel, channelNameForConsoleOutput) {
    channel.onmessage = function (event) {
        console.debug(channelNameForConsoleOutput, 'received a message:', event.data);
    };

    channel.onopen = function () {
        channel.send('first text message over RTP data ports');
    };
    channel.onclose = function (e) {
        console.error(e);
    };
    channel.onerror = function (e) {
        console.error(e);
    };
}
   */
  
}