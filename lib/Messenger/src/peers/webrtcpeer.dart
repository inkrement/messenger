part of messenger;

//TODO: support multiconnections
//TODO: signalingchannel

class WebRtcPeer extends Peer{
  RtcPeerConnection rtcPeerConnection;
  var dataChannel;  
  Map iceServers = {'iceServers':[{'url':'stun:stun.l.google.com:19302'}]};
  var pcConstraint = {};
  Map dataChannelOptions = {};
  
  
  /**
   * constructor
   */
  WebRtcPeer([name="sd"]){
    //log.info("started new JsWebRtcPeer!");
    
    /* init attributes */
    readyStateEvent = new StreamController.broadcast();
    this.name = name;
    
    /* create RTCPeerConnection */
    rtcPeerConnection = new RtcPeerConnection(iceServers); //TODO: add pcConstraints
    
    //log.fine("created PeerConnection");
    
    rtcPeerConnection.onDataChannel.listen((event){
      log.fine("datachannel received");
      
      dataChannel = event.channel;
      /* set channel events */
      dataChannel.onmessage = (x)=>print("rtc message callback: " + x);
      
      dataChannel.onopen = (x)=>changeReadyState(dataChannel.readyState);
      dataChannel.onclose = (x)=>changeReadyState(dataChannel.readyState);
      //dataChannel.onerror = (x)=>print("rtc error callback");
      
      readyState = dataChannel.readyState;
    });
  }
  
  
  /**
   * connect to WebrtcPeer
   */
  connect(WebRtcPeer o){
    log.info("try to connect to: " + o.name);
    
    rtcPeerConnection.onIceCandidate.listen((event) { 
      
      log.info(event.runtimeType.toString());

      if(event.candidate != null)
        o.rtcPeerConnection.addIceCandidate(event.candidate, ()=>print("wuhuu"), (_) => print("error"));
      
        try{
          //o.rtcPeerConnection.addIceCandidate(event.candidate, ()=>print("works"), (_)=>print("error ice candidate"));
          
         // log.warning(event.candidate.toString());
          
          
        } catch(e){
          log.warning("bob error: could not add ice candidate " + e.toString());
        }
        
    });
    
    
    o.rtcPeerConnection.onIceCandidate.listen((event) { 
     
      if(event.candidate != null)
        try{
          
          //log.warning(test.toString());
          
          //var icecandidate = event.candidate;
          //log.info("icecandidate: " + icecandidate);
          //rtcPeerConnection.addIceCandidate(js.map(icecandidate));
        } catch(e){
          log.warning("alice error: could not add ice candidate " + e.toString());
        }
    });
    

    
    try {
      dataChannel = rtcPeerConnection.createDataChannel("sendDataChannel", dataChannelOptions);
      log.info('Created send data channel');
      
      
      dataChannel.onopen = (_)=>changeReadyState(dataChannel.readyState);
      dataChannel.onclose = (_)=>changeReadyState(dataChannel.readyState);
      
      rtcPeerConnection.createOffer().then((sdp_alice){
        log.info("create offer");
        
        rtcPeerConnection.setLocalDescription(sdp_alice);
        o.rtcPeerConnection.setRemoteDescription(sdp_alice);
        
        o.rtcPeerConnection.createAnswer().then((sdp_bob){
          log.info("create answer");
          o.rtcPeerConnection.setLocalDescription(sdp_bob);
          rtcPeerConnection.setRemoteDescription(sdp_bob);
          
          //test datachannel
          //dataChannel.send("test");
        });
      });
      
      
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
    dataChannel.send(msg.toString());
  }
  
}


//class WebRtcPeer extends Peer{
  /*
  RtcDataChannel bob_dc;
   
  RtcDataChannel alice_dc;
  
  var mediaConstraints = {
                        /*  "optional": [],
                          "mandatory": {
                            "OfferToReceiveAudio": false, // Hmm!!
                            "OfferToReceiveVideo": false // Hmm!!
                          }*/
  };
  
  log.info("start webrtc");
  
  RtcPeerConnection alice = new RtcPeerConnection(
      {"iceServers": [{"url": "stun:stun.l.google.com:19302"}]},  
        {"optional" : [{"RtpDataChannels": true}]}
  );
  
  RtcPeerConnection bob = new RtcPeerConnection(
      {"iceServers": [{"url": "stun:stun.l.google.com:19302"}]},  
        {"optional" : [{"RtpDataChannels": true}]}
  );
  
  alice.onIceConnectionStateChange.listen((event){
    log.info("alice: iceConnectionStateChange");
  });
  
  alice.onSignalingStateChange.listen((event){
    log.info("alice: signalingChange event");
  });
  
  bob.onIceConnectionStateChange.listen((event){
    log.info("bob: iceConnectionStateChange");
  });
  
  bob.onSignalingStateChange.listen((event){
    log.info("bob: signalingChange event");
  });
  
  
  
  /*alice.onNegotiationNeeded.listen((var data){
    log.info("1# alice: onnegotiation needed");
    
    
      
    }); 
  });*/

  bob.onIceCandidate.listen((evt) {
    if (evt.candidate)
      print(evt.cancelable);
  });
  bob.onDataChannel.listen((var dc){
    log.info("#3 bob got datachannel!");
    
    bob_dc = dc.channel;
    
    log.info(bob_dc.readyState);
    
    //bob_dc.onOpen.listen((var data){
    //  log.info("bobs channel opened");
      
      bob_dc.onMessage.listen((var data){
        log.info("bob: " + data);
      });
      
      
      
      log.info("bob: send");
      
      log.info(dc.channel.negotiated.toString());
      log.info(dc.channel.readyState);
      dc.channel.sendString("hallo von bob");
    //});
    
  });

  alice.onIceCandidate.listen((evt) {
    if(evt.candidate != null)
      bob.addIceCandidate(evt.candidate, (){
        log.info("seems to work");
      }, (var error){
        print(error.toString());
        
      });
  });
  
  
  log.info("alice: create dc");
  
  alice_dc = alice.createDataChannel("somelablel", {"reliable": false}); //fires onnegotiation needed
  
  log.info("alice set handler");
  
  alice_dc.onMessage.listen((var data){
    log.info("alice: received " + data);
    
    //bouce message
    alice_dc.sendString(data);
  });
  
  
  alice_dc.onOpen.listen((var data){
    log.info("alice dc opened");
    
    alice_dc.sendString("test von alice");
  });
  
  alice_dc.onClose.listen((var data){
    log.info("alice dc closed");
  });
 
  
  alice.createOffer(mediaConstraints).then((var sdp_alice){
    log.info('2# alice: created offer');
    //got offer
    alice.setLocalDescription(sdp_alice);
    bob.setRemoteDescription(sdp_alice);
    
    bob.createAnswer(mediaConstraints).then((RtcSessionDescription sdp_bob) {
      log.info('3# bob: created answer');
      bob.setLocalDescription(sdp_bob);
      alice.setRemoteDescription(sdp_bob);
      
      log.info("desciptions set");
      
      bob_dc.sendString("tesst");
      alice_dc.sendString("rest");
      
      
    });
    
  });
   */
//}
