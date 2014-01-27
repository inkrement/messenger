import 'dart:html';
import "package:webrtc/Messenger/messenger.dart";
import 'package:logging/logging.dart';

void main() {
  
/**
 * TODO
 */
  
  //Messenger msg = new Messenger();
  
  Peer alice = new Peer("alice_sender", Level.OFF);
  Peer bob = new Peer("bob_receiver", Level.OFF);
  
  //setup signaling channel
  MessagePassing alice_sc = new MessagePassing();
  MessagePassing bob_sc = new MessagePassing();
  alice_sc.connect(bob_sc.identityMap());
  bob_sc.connect(alice_sc.identityMap());
  
  
  //set callbacks
  bob.newMessageController.stream.listen(
      (NewMessageEvent e){
        var element = querySelector('#sample_container_id');
        element.text = 'test';
      }
  );
  
  //connect peer
  JsDataChannelConnection alice_c = new JsDataChannelConnection(bob_sc, Peer.parent_log);
  JsDataChannelConnection bob_c = new JsDataChannelConnection(alice_sc, Peer.parent_log);
  alice.listen(alice_c);
  bob.connect(bob_c);
  
  bob.newMessageController.add(new NewMessageEvent(new Message("teeest")));
  alice.multicast(new Message("Hi"));
  
  
}
