import 'package:unittest/unittest.dart';
import 'package:webrtc/Messenger/messenger.dart';

import 'package:unittest/html_config.dart';
import 'dart:mirrors';
import 'dart:async';

void main() {
  
  /* setup html environment */
  useHtmlConfiguration();
  
  //test Constructor
  test('Webrtc Status', (){
    JsWebRtcPeer alice = new JsWebRtcPeer();
    JsWebRtcPeer bob = new JsWebRtcPeer();
  });
  
  test('Webrtc types peerconnection',(){
    JsWebRtcPeer alice = new JsWebRtcPeer();

    expect("[object RTCPeerConnection]", alice.rtcPeerConnection.toString());
  });
  
  
  test('Webrtc types datachannel',(){
    JsWebRtcPeer alice = new JsWebRtcPeer();
    
    InstanceMirror myClassInstanceMirror = reflect(alice);
    //String type = myClassInstanceMirror.type;
    //logMessage();
    
    
    //expect("", myClassInstanceMirror.type);
  });
  
  test('Webrtc has icecandidates',(){
    JsWebRtcPeer alice = new JsWebRtcPeer();
    JsWebRtcPeer bob = new JsWebRtcPeer();
    
    expect(alice.connect(bob), completes);
    
    /*
    new Timer(new Duration(milliseconds:100), expectAsync0((){
        
      alice.connect(bob).then((_){
        int sum = alice.iceCandidates.length + bob.iceCandidates.length;
        
        logMessage(sum.toString());
        expect(sum, predicate((x) => (x > 0), "is bigger than 0"));
      });
        
    }));*/
    
    
  });
  
  
  
  //test connect
  
  test('Webrtc connect',(){
    JsWebRtcPeer alice = new JsWebRtcPeer();
    JsWebRtcPeer bob = new JsWebRtcPeer();
    
    alice.connect(bob);
    //InstanceMirror myClassInstanceMirror = reflect(alice);
    //String type = myClassInstanceMirror.type;
    //logMessage();
    
    
    //expect("", myClassInstanceMirror.type);
  });
  
  
}