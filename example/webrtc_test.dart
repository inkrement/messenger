//import 'dart:html';
import "package:messenger/messenger.dart";
import 'package:logging/logging.dart';

void main() {
 
          Peer alice = new Peer("alice_s3", Level.ALL);
          Peer bob = new Peer("bob_s3", Level.ALL);
          
          //setup signaling channels
          MessagePassing alice_bob_sc = new MessagePassing();
          MessagePassing bob_alice_sc = new MessagePassing();
          
          alice_bob_sc.connect(bob_alice_sc.identityMap());
          bob_alice_sc.connect(alice_bob_sc.identityMap());
          
          
          //set callbacks
          String s_alice = "some random string from alice";
          String s_bob = "some random string from bob";
          Message tm_alice = new Message(s_alice);
          Message tm_bob = new Message(s_bob);
          
          //each sould receive two messages
          alice.onReceive.listen((NewMessageEvent mevent){
            print("alice revceived message: " + mevent.getMessage().toString());
          });

          bob.onReceive.listen((NewMessageEvent mevent){
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
          
          bob.newConnectionController.stream.listen((_){
            if(bob.connections.length == 1){
              bob.multicast(tm_bob);
            }
          });
          
          /*
           * create connections
           */
          WebRtcDataChannel a_b_c = new WebRtcDataChannel(alice_bob_sc);
          WebRtcDataChannel b_a_c = new WebRtcDataChannel(bob_alice_sc);
          
          
          //connect alice/bob bob/alice
          alice.listen(b_a_c);
          bob.connect(a_b_c);
}
