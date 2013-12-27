import 'package:unittest/unittest.dart';
import 'package:webrtc/Messenger/messenger.dart';

import 'package:unittest/html_config.dart';
//import 'dart:mirrors';
//import 'dart:async';


void main() {
  
  /// setup html environment 
  useHtmlConfiguration();
  
  /**
   * expect to construct new Object without catching a exception
   */
  test('Webrtc Status', (){
    JsWebRtcPeer alice = new JsWebRtcPeer();
    JsWebRtcPeer bob = new JsWebRtcPeer();
  });
  
  /**
   * The type od a new rtcPeerConnection should be
   * RTCPeerConnection
   */
  test('Webrtc types peerconnection',(){
    JsWebRtcPeer alice = new JsWebRtcPeer();

    expect(alice.rtcPeerConnection.toString(), "[object RTCPeerConnection]");
  });
  
  
  /**
   * New Peer should not have a datachannel.
   * Therefore readyState is initialized with "none"
   */
  test('Webrtc datachannel status',(){
    JsWebRtcPeer alice = new JsWebRtcPeer();

    expect(alice.readyState, "none");
  });
  
  /**
   * Test Connection
   */
  test('Webrtc connect',(){
    JsWebRtcPeer alice = new JsWebRtcPeer("alice");
    JsWebRtcPeer bob = new JsWebRtcPeer("bob");
    
    alice.connect(bob);
  });
  
  
  
  
  /*
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
    
    //expect(alice.connect(bob), completes);
   
  });
  
  
  test("testing a future", () {
    Compute compute = new Compute();    
    Future<Map> future = compute.sumIt([1, 2, 3]);
    expect(future, completion(equals({"value" : 6})));
  });
  */
  
  
  //test connect
  

  
  
}