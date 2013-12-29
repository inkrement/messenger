library unittest.messagepassing;

import 'package:unittest/unittest.dart';
import 'package:webrtc/Messenger/messenger.dart';

main() {
  test('SendAndReceive', (){
    MessagePassingPeer alice = new MessagePassingPeer();
    MessagePassingPeer bob = new MessagePassingPeer();
    
    bob.onReceive.listen((NewMessageEvent data){
      expect(data.getMessage(), "something new");
    });
    
    alice.sendString(bob, "something new");
  });
}