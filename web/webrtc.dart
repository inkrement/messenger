//import 'dart:html';
import "package:WebRTCMessenger/WebRTCMessenger/webrtcmessenger.dart";


void main() {
  
/**
 * test call function to inspect js-output
 */
 
          
          Peer alice = new Peer("alice_s3");
          Peer bob = new Peer("bob_s3");
          Peer clark = new Peer("clark_s3");
          
          //setup signaling channels
          JSCallbackSignaling alice_bob_sc = new JSCallbackSignaling();
          
          alice_bob_sc.connect(null);
          
          
          //set callbacks
          
          String s_alice = "some random string from alice";  
          Message tm_alice = new Message(s_alice);

          
          //each sould receive two messages
          alice.onReceive.listen((NewMessageEvent mevent){
            print("alice revceived message: " + mevent.getMessage().toString());
          });

          /*
           * send messages
           */
          alice.newConnectionController.stream.listen((_){
            if(alice.connections.length == 1){
              alice.multicast(tm_alice);
            }
          });
          
          
          /*
           * create connections
           */
          WebRtcDataChannel a_b_c = new WebRtcDataChannel(alice_bob_sc);
        
          //connect alice/bob bob/alice
          alice.listen(a_b_c);
          //bob.connect(a_b_c);
          
  
}
