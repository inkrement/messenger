import 'dart:html';
import 'dart:mirrors';
import 'dart:async';
import 'dart:js';

class PeerProxyConnection implements RtcPeerConnection{
  final RtcPeerConnection _peerConnection;
  
  PeerProxyConnection(Map<dynamic, dynamic> rtcIceServers,[ Map<dynamic, dynamic> mediaConstraints]):
    _peerConnection = new RtcPeerConnection(rtcIceServers, mediaConstraints);

  noSuchMethod(Invocation invocation) =>
      reflect(_peerConnection).delegate(invocation);
  
<<<<<<< Updated upstream
  Stream<RtcIceCandidateEvent> onIceCandidatePatch(){
    //do something
  }
  
  /*
  PeerProxyConnection(Map<dynamic, dynamic> rtcIceServers, Map<dynamic, dynamic> mediaConstraints){
    //super(rtcIceServers, mediaConstraints);
  }*/
    
=======
  //webrtc
  RtcDataChannel bob_dc;
  RtcDataChannel alice_dc;
  var mediaConstraints = {};
>>>>>>> Stashed changes
  
}


void main() {
  
  RtcPeerConnection alice = new PeerProxyConnection(
      {"iceServers": [{"url": "stun:stun.l.google.com:19302"}]}
  );
  
  RtcPeerConnection bob = new PeerProxyConnection(
      {"iceServers": [{"url": "stun:stun.l.google.com:19302"}]}
  );
  
<<<<<<< Updated upstream
  alice.createDataChannel("somelablel", {});
  
  alice.onNegotiationNeeded.listen((var data){
    print("fired: onnegotiation needed");
    
    alice.createOffer({}).then((var offer){
      //got offer
      alice.setLocalDescription(offer);
      bob.setRemoteDescription(offer);
      
      bob.createAnswer().then((RtcSessionDescription sdp2) {
        bob.setLocalDescription(sdp2);
        alice.setRemoteDescription(sdp2);   
      });
      
    }); 
=======
  alice.onIceConnectionStateChange.listen((Event event){
    log.info("alice: iceConnectionStateChange");
  });
  
  alice.onSignalingStateChange.listen((Event event){
    log.info("alice: signalingChange event");
  });
  
  bob.onIceConnectionStateChange.listen((Event event){
    log.info("bob: iceConnectionStateChange");
  });
  
  bob.onSignalingStateChange.listen((Event event){
    log.info("bob: signalingChange event");
>>>>>>> Stashed changes
  });

  bob.onIceCandidate.listen((RtcIceCandidateEvent event) {
    log.warning("bob: new ice candidate");
    
    alice.addIceCandidate(event.candidate, (){
      log.info("alice: ice candidate added");
    }, (var error){
      log.warning("alice: could not add ice candidate");
    });
  });
<<<<<<< Updated upstream

  alice.onIceCandidate.listen((evt) {
    if(evt.candidate != null)
      bob.addIceCandidate(evt.candidate, (){
        print("seems to work");
      }, (var error){
        print(error.toString());
=======
  
  bob.onDataChannel.listen((var dc){
    log.info("#3 bob got datachannel!");
    
    bob_dc = dc.channel;
 
    bob_dc.onMessage.listen((var data){
      log.info("bob: " + data);
    });
      
    log.info("bob: send");
    bob_dc.sendString("hallo von bob");    
  });

  alice.onIceCandidate.listen((RtcIceCandidateEvent event) {
    
    if(event.candidate != null){
      log.info("alice: new ice candidate");
      
      bob.addIceCandidate(event.candidate, (){
        log.info("bob: ice candidate added");
      }, (var error){
        log.warning("bob: could not add ice candidate");
      });
    }
      
  });
  
  alice.onNegotiationNeeded.listen((Event event){
    log.warning("alice: onNegotiation needed!");
    
    alice.createOffer(mediaConstraints).then((var sdp_alice){
      log.info('2# alice: created offer');
      //got offer
      alice.setLocalDescription(sdp_alice);
      bob.setRemoteDescription(sdp_alice);
      
      bob.createAnswer(mediaConstraints).then((RtcSessionDescription sdp_bob) {
        log.info('3# bob: created answer');
        bob.setLocalDescription(sdp_bob);
        alice.setRemoteDescription(sdp_bob);
>>>>>>> Stashed changes
        
        log.info("desciptions set");
        
        bob_dc.sendString("tesst");
        alice_dc.sendString("rest");
      });
    });
  });
  
<<<<<<< Updated upstream
=======
  log.info("alice: create dc");
  alice_dc = alice.createDataChannel("somelablel", {"reliable": false}); //fires onnegotiation needed
  
  log.info("alice: set handler");
  
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
  
>>>>>>> Stashed changes
  
}
