library unittest.jsrtcpeer;

import 'package:unittest/unittest.dart';
import 'package:webrtc/Messenger/messenger.dart';
import 'package:logging/logging.dart';
import 'dart:async';

void main() {
  
  group('JS RTC Peer', () {
    
    setUP(){
      
      // override configuration to set custom timeout
      SimpleConfiguration sc = new SimpleConfiguration();
      sc.timeout = new Duration(seconds: 1);
      unittestConfiguration = sc;
      
    }
    
    
    /**
     * 1 expect to construct new Object without catching a exception
     */
    test('JSWebrtc Status and Logs', (){
      JsWebRtcPeer alice = new JsWebRtcPeer("alice", Level.OFF);
      JsWebRtcPeer bob = new JsWebRtcPeer("bob", Level.OFF);
    });
    
    /**
     * 2 The type od a new rtcPeerConnection should be
     * RTCPeerConnection
     */
    test('JSWebrtc create components',(){
      JsWebRtcPeer alice = new JsWebRtcPeer("alice", Level.OFF);
      MessagePassing alice_sc = new MessagePassing();
      JsWebRtcConnection alice_cn = new JsWebRtcConnection();
    });
    
    
    /**
     * 3 New Peer should not have a datachannel.
     * Therefore readyState is initialized with "none"
     */
    test('JSWebrtc datachannel status',(){
      JsWebRtcPeer alice = new JsWebRtcPeer("alice", Level.OFF);
  
      expect(alice.countConnections(), 0);
      
    });
    
  });
  
  
  group('JS Webrtc Connection', (){
    
    
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
      
      //connect peer
      Stream<NewConnectionEvent> s_a = alice.listen(bob_sc);
      Stream<NewConnectionEvent> s_b = bob.connect(alice_sc);
      
      s_a.listen(expectAsync1((_){}));
      s_b.listen(expectAsync1((_){}));
    });
    
    
    /**
     * test connection
     */
    
    test('check connection etablishment', (){
      JsWebRtcPeer alice = new JsWebRtcPeer("alice", Level.OFF);
      JsWebRtcPeer bob = new JsWebRtcPeer("bob", Level.OFF);
      
      //setup signaling channel
      MessagePassing alice_sc = new MessagePassing();
      MessagePassing bob_sc = new MessagePassing();
      alice_sc.connect(bob_sc.identityMap());
      bob_sc.connect(alice_sc.identityMap());
      
      
      //set callbacks
      alice.newConnectionController.stream.listen(
          expectAsync1((_)=>expect(alice.connections.length, 1))
          );
      
      bob.newConnectionController.stream.listen(
          expectAsync1((_)=>expect(bob.connections.length, 1))
          );
      
      //connect peer
      alice.listen(bob_sc);
      bob.connect(alice_sc);
    });
    
    
    /**
     * test connection
     */
    
    test('check connection management', (){
      JsWebRtcPeer alice = new JsWebRtcPeer("alice_ccm", Level.OFF);
      JsWebRtcPeer bob = new JsWebRtcPeer("bob_ccm", Level.OFF);
      
      //setup signaling channel
      MessagePassing alice_sc = new MessagePassing();
      MessagePassing bob_sc = new MessagePassing();
      alice_sc.connect(bob_sc.identityMap());
      bob_sc.connect(alice_sc.identityMap());
      
      
      //set callbacks
      alice.newConnectionController.stream.listen(
          expectAsync1((_)=>expect(alice.connections.keys.first, bob.id))
          );
      
      bob.newConnectionController.stream.listen(
          expectAsync1((_)=>expect(bob.connections.keys.first, alice.id))
          );
      
      //connect peer
      alice.listen(bob_sc);
      bob.connect(alice_sc);
    });
    
    
    /**
     * test DataChannel's readyState opens
     
    
    test('JSwebrtc datachannel', (){
      bool bob_gotmessage = false;
      
      JsWebRtcPeer alice = new JsWebRtcPeer("alice", Level.OFF);
      JsWebRtcPeer bob = new JsWebRtcPeer("bob", Level.OFF);
      
      //setup signaling channel
      MessagePassing alice_sc = new MessagePassing();
      MessagePassing bob_sc = new MessagePassing();
      alice_sc.connect(bob_sc.identityMap());
      bob_sc.connect(alice_sc.identityMap());
      
      //TODO: maybe not the first call
      _callback(ReadyState status) => expect(status, ReadyState.DC_OPEN);
      
      //bob should receive something
      bob.newMessageController.stream.listen(expectAsync1((){}));
      
      //connect peer
      alice.listen(bob_sc);
      bob.connect(alice_sc);
      
      alice.send(bob.id, new Message("some random string"));
    });
    */
    
    /**
     * send
     
    
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
    
    */
    
  });
}