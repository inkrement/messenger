//import 'dart:html';
import "package:webrtc/Messenger/messenger.dart";


void main() {
  
/**
 * TODO
 */
  
  //Messenger msg = new Messenger();
  
  Peer alice = new Peer("alice_c");
  Peer bob = new Peer("bob_c");
  
  //setup signaling channel
  MessagePassing alice_sc = new MessagePassing();
  MessagePassing bob_sc = new MessagePassing();
  
  //connect signaling channel
  alice_sc.connect(bob_sc.identityMap());
  bob_sc.connect(alice_sc.identityMap());
  
  //connect peer
  JsDataChannelConnection alice_c = new JsDataChannelConnection(bob_sc, Peer.parent_log);
  JsDataChannelConnection bob_c = new JsDataChannelConnection(alice_sc, Peer.parent_log);
  Stream<NewConnectionEvent> s_a = alice.listen(alice_c);
  Stream<NewConnectionEvent> s_b = bob.connect(bob_c);
  
  
}
