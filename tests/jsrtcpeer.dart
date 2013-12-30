library unittest.jsrtcpeer;

import 'package:unittest/unittest.dart';
import 'package:webrtc/Messenger/messenger.dart';
import 'package:logging/logging.dart';

void main() {
  
  /**
   * expect to construct new Object without catching a exception
   */
  test('JSWebrtc Status and Logs', (){
    JsWebRtcPeer alice = new JsWebRtcPeer("alice", Level.OFF);
    JsWebRtcPeer bob = new JsWebRtcPeer("bob", Level.OFF);
  });
  
  /**
   * The type od a new rtcPeerConnection should be
   * RTCPeerConnection
   */
  test('JSWebrtc create components',(){
    JsWebRtcPeer alice = new JsWebRtcPeer("alice", Level.OFF);
    MessagePassing alice_sc = new MessagePassing();
    JsWebRtcConnection alice_cn = new JsWebRtcConnection();
  });
  
  
  /**
   * New Peer should not have a datachannel.
   * Therefore readyState is initialized with "none"
   */
  test('JSWebrtc datachannel status',(){
    JsWebRtcPeer alice = new JsWebRtcPeer("alice", Level.OFF);

    expect(alice.connections(), 0);
    
  });
  
  
  /**
   * Test connection
   */
  test('JSWebrtc connect',(){
    JsWebRtcPeer alice = new JsWebRtcPeer("alice_c", Level.OFF);
    JsWebRtcPeer bob = new JsWebRtcPeer("bob_c", Level.OFF);
    
    //setup signaling channel
    MessagePassing alice_sc = new MessagePassing();
    MessagePassing bob_sc = new MessagePassing();
    
    //connect signaling channel
    alice_sc.connect(bob_sc.identityMap());
    bob_sc.connect(alice_sc.identityMap());
    
    //bob.readyStateEvent.stream.listen(expectAsync1((_){}));
    
    //connect peer
    expect(alice.listen(bob_sc), completes);
    expect(bob.connect(alice_sc), completes);
  });
  
  
  
  /**
   * test DataChannel's readyState opens
   */
  
  test('JSwebrtc datachannel', (){
    JsWebRtcPeer alice = new JsWebRtcPeer("alice", Level.OFF);
    JsWebRtcPeer bob = new JsWebRtcPeer("bob", Level.OFF);
    
    //setup signaling channel
    MessagePassing alice_sc = new MessagePassing();
    MessagePassing bob_sc = new MessagePassing();
    
    //connect signaling channel
    alice_sc.connect(bob_sc.identityMap());
    bob_sc.connect(alice_sc.identityMap());
    
    //TODO: maybe not the first call
    _callback(ReadyState status) => expect(status, ReadyState.DC_OPEN);
    
    //alice.readyStateEvent.stream.listen(expectAsync1(_callback));
    
    
    
    //connect peer
    alice.listen(bob_sc);
    bob.connect(alice_sc);
    
  });
  
  /**
   * send
   */
  
  test('JSwebrtc send', (){
    
    String something = "some lousy string";
    
    JsWebRtcPeer alice = new JsWebRtcPeer("alice_s", Level.OFF);
    JsWebRtcPeer bob = new JsWebRtcPeer("bob_s", Level.OFF);
    
    //setup signaling channel
    MessagePassing alice_sc = new MessagePassing();
    MessagePassing bob_sc = new MessagePassing();
    
    //connect signaling channel
    alice_sc.connect(bob_sc.identityMap());
    bob_sc.connect(alice_sc.identityMap());
    
    //TODO: maybe not the first call
    _callback(NewMessageEvent me){
      expect(me.data.msg, something);
    }
    
    alice.onReceive.listen(expectAsync1(_callback));
    
    //connect peer
    alice.listen(bob_sc);
    bob.connect(alice_sc);
    
    //send
    //_callback2(ReadyState status) {
    //  if(status == ReadyState.DC_OPEN)
    bob.send(bob.hashCode, new Message(something));
    //  };
    
    //alice.readyStateEvent.stream.listen(expectAsync1(_callback2));
    
   // bob.send(alice, new Message(something));
    
  });
}