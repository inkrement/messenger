library unittest.signaling.messagepassing;

import 'package:unittest/unittest.dart';
import 'package:webrtc/Messenger/src/signaling.dart';
import 'package:webrtc/Messenger/src/events.dart';
import 'package:webrtc/Messenger/src/message.dart';

void main() {
  
  /**
   * expect to construct new Object without catching a exception
   */
  test('create signaling channels', (){
    MessagePassing alice = new MessagePassing();
    MessagePassing bob = new MessagePassing();
  });
  
  /**
   * test send and receive functionality of message passing objects
   */
  test('send and receive data over signaling channels', (){
    MessagePassing alice = new MessagePassing();
    MessagePassing bob = new MessagePassing();
    
    String message = "some arbitrary message";
    
    //connect
    alice.connect(bob.identityMap());
    bob.connect(alice.identityMap());
    
    //setup receiver
    _callback(NewMessageEvent event) => expect(event.data.msg, message);
    alice.onReceive.listen(expectAsync1(_callback));
    
    //send
    bob.send(new Message(message));
  });

  
  
}