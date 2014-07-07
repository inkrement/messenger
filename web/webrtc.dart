//import 'dart:html';
import "package:WebRTCMessenger/WebRTCMessenger/webrtcmessenger.dart";


/**
 * test call function to inspect js-output
 */

void main() {
  Peer alice = new Peer("alice");
  String s_alice = "some random string from alice";  
  Message tm_alice = new Message(s_alice);
  
  //setup signaling channels and configure connection
  JSCallbackSignaling signalingChannel = new JSCallbackSignaling();
  signalingChannel.connect(null);
  
  alice.onReceive.listen((NewMessageEvent mevent){
    print("alice revceived message: " + mevent.getMessage().toString());
  });
  
  //send message if connected
  alice.newConnectionController.stream.listen((_){
    if(alice.connections.length == 1){
      alice.multicast(tm_alice);
    }
  });
  
  
  //establish webrtc connection
  WebRtcDataChannel webRTCChannel = new WebRtcDataChannel(signalingChannel);
  
  Future<int> f = webRTCChannel.connect();
                  
  f.then((int id) {
    alice.add(id, webRTCChannel);
  });
}
