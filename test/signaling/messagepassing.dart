library unittest.signaling.messagepassing;

import 'package:unittest/unittest.dart';
import 'package:messenger/messenger/src/signaling.dart';

void main() {
  
  group('messagepassing',(){
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
      _callback(NewMessageEvent event) => expect(event.data.toString(), message);
      alice.onReceive.listen(expectAsync(_callback));
      
      //send
      bob.send(new Message(message));
    });
  });
  

  
  
}