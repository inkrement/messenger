part of messenger;

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
