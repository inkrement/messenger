library unittest.jsrtcpeer;

import 'package:unittest/unittest.dart';
import 'package:logging/logging.dart';

import 'package:webrtc/Messenger/src/peer.dart';

void main() {
  
  group('Jswebrtc Connection', () {
    
    
    /**
     * 2 The type od a new rtcPeerConnection should be
     * RTCPeerConnection
     */
    test('JSWebrtc create components',(){
      Peer alice = new Peer("alice", Level.OFF);
      MessagePassing alice_sc = new MessagePassing();
      JsWebRtcConnection alice_cn = new JsWebRtcConnection(alice_sc, new Logger("testlogger"));
    });
    
    
    /**
     * 3 New Peer should not have a datachannel.
     * Therefore readyState is initialized with "none"
     */
    test('JSWebrtc datachannel status',(){
      Peer alice = new Peer("alice", Level.OFF);
  
      expect(alice.countConnections(), 0);
      
    });
    
  });
  
  
  group('JS Webrtc Connection', (){
    
    
    /**
     * Test connection
     */
    test('JSWebrtc connect',(){
      
      
      Peer alice = new Peer("alice_c", Level.OFF);
      Peer bob = new Peer("bob_c", Level.OFF);
      
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
      Peer alice = new Peer("alice_ce", Level.OFF);
      Peer bob = new Peer("bob_ce", Level.OFF);
      
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
      Peer alice = new Peer("alice_ccm", Level.OFF);
      Peer bob = new Peer("bob_ccm", Level.OFF);
      
      //setup signaling channel
      MessagePassing alice_sc = new MessagePassing();
      MessagePassing bob_sc = new MessagePassing();
      alice_sc.connect(bob_sc.identityMap());
      bob_sc.connect(alice_sc.identityMap());
      
      
      //set callbacks
      alice.newConnectionController.stream.listen(
          expectAsync1((_)=>expect(alice.connections.keys.first, bob_sc.id))
          );
      
      bob.newConnectionController.stream.listen(
          expectAsync1((_)=>expect(bob.connections.keys.first, alice_sc.id))
          );
      
      //connect peer
      alice.listen(bob_sc);
      bob.connect(alice_sc);
    });
    
    
    group('multi connections', (){
      
      test('three connections at the same time', (){
        Peer alice = new Peer("alice_m3", Level.OFF);
        Peer bob = new Peer("bob_m3", Level.OFF);
        Peer clark = new Peer("clark_m3", Level.OFF);
        
        //setup signaling channels
        MessagePassing alice_bob_sc = new MessagePassing();
        MessagePassing bob_alice_sc = new MessagePassing();
        
        MessagePassing alice_clark_sc = new MessagePassing();
        MessagePassing clark_alice_sc = new MessagePassing();
        
        MessagePassing clark_bob_sc = new MessagePassing();
        MessagePassing bob_clark_sc = new MessagePassing();
        
        alice_bob_sc.connect(bob_alice_sc.identityMap());
        bob_alice_sc.connect(alice_bob_sc.identityMap());
        
        alice_clark_sc.connect(clark_alice_sc.identityMap());
        clark_alice_sc.connect(alice_clark_sc.identityMap());
        
        clark_bob_sc.connect(bob_clark_sc.identityMap());
        bob_clark_sc.connect(clark_bob_sc.identityMap());
        
        
        //set callbacks
        
        int alice_c = 1;
        int bob_c = 1;
        int clark_c = 1;
        
        alice.newConnectionController.stream.listen(
            expectAsync1((_)=>expect(alice.connections.length, alice_c++), count:2)
        );
        
        bob.newConnectionController.stream.listen(
            expectAsync1((_)=>expect(bob.connections.length, bob_c++), count:2)
        );
        
        clark.newConnectionController.stream.listen(
            expectAsync1((_)=>expect(clark.connections.length, clark_c++), count:2)
        );
        
        
        //connect clark/bob bob/clark
        bob.listen(clark_bob_sc);
        clark.connect(bob_clark_sc);
        
        //connect alice/bob bob/alice
        alice.listen(bob_alice_sc);
        bob.connect(alice_bob_sc);
        
        //connect alice/clark clark/alice
        alice.listen(clark_alice_sc);
        clark.connect(alice_clark_sc);
        
      });
      
      
      
      test('3 clients send messages', (){
        Peer alice = new Peer("alice_s3", Level.INFO);
        Peer bob = new Peer("bob_s3", Level.INFO);
        Peer clark = new Peer("clark_s3", Level.INFO);
        
        //setup signaling channels
        MessagePassing alice_bob_sc = new MessagePassing();
        MessagePassing bob_alice_sc = new MessagePassing();
        
        MessagePassing alice_clark_sc = new MessagePassing();
        MessagePassing clark_alice_sc = new MessagePassing();
        
        MessagePassing clark_bob_sc = new MessagePassing();
        MessagePassing bob_clark_sc = new MessagePassing();
        
        alice_bob_sc.connect(bob_alice_sc.identityMap());
        bob_alice_sc.connect(alice_bob_sc.identityMap());
        
        alice_clark_sc.connect(clark_alice_sc.identityMap());
        clark_alice_sc.connect(alice_clark_sc.identityMap());
        
        clark_bob_sc.connect(bob_clark_sc.identityMap());
        bob_clark_sc.connect(clark_bob_sc.identityMap());
        
        
        //set callbacks
        
        String s = "some random string";
        Message tm = new Message(s);
        
        //each sould receive two messages
        alice.newMessageController.stream.listen(
            expectAsync1((NewMessageEvent e){
              expect(e.data.toString(), s);
            }, count: 2)
        );

        bob.newMessageController.stream.listen(
            expectAsync1((NewMessageEvent e){
              expect(e.data.toString(), s);
            }, count: 2)
        );
        
        clark.newMessageController.stream.listen(
            expectAsync1((NewMessageEvent e){
              expect(e.data.toString(), s);
            }, count: 2)
        );
        
        
        bob.newConnectionController.stream.listen((_){
          if(bob.connections.length > 1){
            logMessage("connected to more than 1 client. looks quite good");
            
            bob.multicast(tm);
          }
        });
        
        clark.newConnectionController.stream.listen((_){
          if(clark.connections.length > 1){
            logMessage("connected to more than 1 client. looks quite good");
            
            clark.multicast(tm);
          }
        });
        
        alice.newConnectionController.stream.listen((_){
          if(alice.connections.length > 1){
            logMessage("connected to more than 1 client. looks quite good");
            
            alice.multicast(tm);
          }
        });
        
        //connect clark/bob bob/clark
        bob.listen(clark_bob_sc);
        clark.connect(bob_clark_sc);
        
        //connect alice/bob bob/alice
        alice.listen(bob_alice_sc);
        bob.connect(alice_bob_sc);
        
        //connect alice/clark clark/alice
        alice.listen(clark_alice_sc);
        clark.connect(alice_clark_sc);

      });
      
    });
    
  });
}