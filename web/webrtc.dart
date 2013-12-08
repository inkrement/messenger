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
  
  Stream<RtcIceCandidateEvent> onIceCandidatePatch(){
    //do something
  }
  
  /*
  PeerProxyConnection(Map<dynamic, dynamic> rtcIceServers, Map<dynamic, dynamic> mediaConstraints){
    //super(rtcIceServers, mediaConstraints);
  }*/
    
  
}


void main() {
  
  RtcPeerConnection alice = new PeerProxyConnection(
      {"iceServers": [{"url": "stun:stun.l.google.com:19302"}]}
  );
  
  RtcPeerConnection bob = new PeerProxyConnection(
      {"iceServers": [{"url": "stun:stun.l.google.com:19302"}]}
  );
  
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
  });

  bob.onIceCandidate.listen((evt) {
    if (evt.candidate)
      print(evt.cancelable);
  });

  alice.onIceCandidate.listen((evt) {
    if(evt.candidate != null)
      bob.addIceCandidate(evt.candidate, (){
        print("seems to work");
      }, (var error){
        print(error.toString());
        
      });
  });
  
  
}
