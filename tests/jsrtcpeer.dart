library unittest.jsrtcpeer;

import 'package:unittest/unittest.dart';
import 'package:webrtc/Messenger/messenger.dart';

void main() {
  
  /**
   * expect to construct new Object without catching a exception
   */
  test('JSWebrtc Status', (){
    JsWebRtcPeer alice = new JsWebRtcPeer();
    JsWebRtcPeer bob = new JsWebRtcPeer();
  });
  
  /**
   * The type od a new rtcPeerConnection should be
   * RTCPeerConnection
   */
  test('JSWebrtc types peerconnection',(){
    JsWebRtcPeer alice = new JsWebRtcPeer();

    expect(alice.rtcPeerConnection.toString(), "[object RTCPeerConnection]");
  });
  
  
  /**
   * New Peer should not have a datachannel.
   * Therefore readyState is initialized with "none"
   */
  test('JSWebrtc datachannel status',(){
    JsWebRtcPeer alice = new JsWebRtcPeer();

    expect(alice.readyState, ReadyState.NEW);
  });
  
  /**
   * Test connection
   */
  test('JSWebrtc connect',(){
    JsWebRtcPeer alice = new JsWebRtcPeer("alice");
    JsWebRtcPeer bob = new JsWebRtcPeer("bob");
    
    //setup signaling channel
    MessagePassing alice_sc = new MessagePassing();
    MessagePassing bob_sc = new MessagePassing();
    
    //connect signaling channel
    alice_sc.connect(bob_sc.identityMap());
    bob_sc.connect(alice_sc.identityMap());
    
    //connect peer
    expect(alice.connect(bob_sc), completes);
    expect(bob.connect(alice_sc), completes);
  });
  
  
  
  /**
   * test DataChannel's readyState opens
   */
  
  test('JSwebrtc datachannel', (){
    JsWebRtcPeer alice = new JsWebRtcPeer("alice");
    JsWebRtcPeer bob = new JsWebRtcPeer("bob");
    
    //setup signaling channel
    MessagePassing alice_sc = new MessagePassing();
    MessagePassing bob_sc = new MessagePassing();
    
    //connect signaling channel
    alice_sc.connect(bob_sc.identityMap());
    bob_sc.connect(alice_sc.identityMap());
    
    //TODO: maybe not the first call
    _callback(ReadyState status) => expect(status, ReadyState.DC_OPEN);
    
    alice.readyStateEvent.stream.listen(expectAsync1(_callback));
    
    //connect peer
    alice.connect(bob_sc);
    bob.connect(alice_sc);
    
  });
  
  
}