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
   * Test connection
   */
  test('Webrtc connect',(){
    JsWebRtcPeer alice = new JsWebRtcPeer("alice");
    JsWebRtcPeer bob = new JsWebRtcPeer("bob");
    
    expect(alice.connect(bob), completes);
  });
  
  
  
  /**
   * test DataChannel's readyState opens
   */
  test('webrtc datachannel', (){
    JsWebRtcPeer alice = new JsWebRtcPeer("alice");
    JsWebRtcPeer bob = new JsWebRtcPeer("bob");
    
    _callback(String status) => expect(status, "open");
    
    alice.readyStateEvent.stream.listen(expectAsync1(_callback));
    
    alice.connect(bob);
    
  });
  
  
}