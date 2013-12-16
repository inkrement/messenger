import 'package:unittest/unittest.dart';
import 'package:webrtc/Messenger/messenger.dart';

import 'package:unittest/html_config.dart';
import 'dart:mirrors';

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