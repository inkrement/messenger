import 'package:unittest/unittest.dart';
import 'package:webrtc/Messenger/messenger.dart';

import 'package:unittest/html_config.dart';

void main() {
  
  /* setup html environment */
  useHtmlConfiguration();
  
  test('Webrtc Status', (){
    JsWebRtcPeer alice = new JsWebRtcPeer();
    JsWebRtcPeer bob = new JsWebRtcPeer();
  });
  
  
  //test('SendAndReceive', (){
    /*MessagePassingPeer alice = new MessagePassingPeer();
    MessagePassingPeer bob = new MessagePassingPeer();
    
    bob.onReceive.listen((NewMessageEvent data){
      expect(data.getMessage(), "something new");
    });
    
    alice.sendString(bob, "something new");*/
 // });
}