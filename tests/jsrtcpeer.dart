library unittest.jsrtcpeer;

import 'package:unittest/unittest.dart';
import 'package:webrtc/Messenger/messenger.dart';

void main() {
  
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
  
  /**
   * test status opens
   */
  test('webrtc datachannel open', (){
    JsWebRtcPeer alice = new JsWebRtcPeer("alice");
    JsWebRtcPeer bob = new JsWebRtcPeer("bob");
    
    alice.readyStateEvent.stream.listen((String status){
      if(status == "open")
          expectAsync0((){});
    });
    
    alice.connect(bob);
    
  });
  
  
}