library unittest.rtcpeer;

import 'package:unittest/unittest.dart';
import 'package:logging/logging.dart';

import 'package:messenger/messenger/src/peer.dart';

void main() {
  
  Level llevel = Level.ALL;
  
  group('WebRTC Connection', () {
    
    
    /**
     * 2 The type od a new rtcPeerConnection should be
     * RTCPeerConnection
     */
    test('JSWebrtc create components',(){
      Peer alice = new Peer("alice", llevel);
      MessagePassing alice_sc = new MessagePassing();
      WebRtcDataChannel alice_cn = new WebRtcDataChannel(alice_sc);
    });
    
    
    /**
     * 3 New Peer should not have a datachannel.
     * Therefore readyState is initialized with "none"
     */
    test('WebRTC datachannel status',(){
      Peer alice = new Peer("alice", llevel);
  
      expect(alice.countConnections(), 0);
      
    });
    
  });
  
  
  group('Webrtc Connection', (){
    
    
    /**
     * Test connection
     */
    test('WebRTC connect',(){
      
      
      Peer alice = new Peer("alice_c", llevel);
      Peer bob = new Peer("bob_c", llevel);
      
      //setup signaling channel
      MessagePassing alice_sc = new MessagePassing();
      MessagePassing bob_sc = new MessagePassing();
      
      //connect signaling channel
      alice_sc.connect(bob_sc.identityMap());
      bob_sc.connect(alice_sc.identityMap());
      
      //connect peer
      WebRtcDataChannel alice_c = new WebRtcDataChannel(bob_sc);
      WebRtcDataChannel bob_c = new WebRtcDataChannel(alice_sc);
      Stream<NewConnectionEvent> s_a = alice.listen(alice_c);
      Stream<NewConnectionEvent> s_b = bob.connect(bob_c);
      
      s_a.listen(expectAsync((_){}));
      s_b.listen(expectAsync((_){}));
    });
    
    
    /**
     * test connection
     */
    
    test('check connection etablishment', (){
      Peer alice = new Peer("alice_ce", llevel);
      Peer bob = new Peer("bob_ce", llevel);
      
      //setup signaling channel
      MessagePassing alice_sc = new MessagePassing();
      MessagePassing bob_sc = new MessagePassing();
      alice_sc.connect(bob_sc.identityMap());
      bob_sc.connect(alice_sc.identityMap());
      
      
      //set callbacks
      alice.newConnectionController.stream.listen(
          expectAsync((_)=>expect(alice.connections.length, 1))
          );
      
      bob.newConnectionController.stream.listen(
          expectAsync((_)=>expect(bob.connections.length, 1))
          );
      
      //connect peer
      WebRtcDataChannel alice_c = new WebRtcDataChannel(bob_sc);
      WebRtcDataChannel bob_c = new WebRtcDataChannel(alice_sc);
      Stream<NewConnectionEvent> s_a = alice.listen(alice_c);
      Stream<NewConnectionEvent> s_b = bob.connect(bob_c);
    });
    
    
    /**
     * test connection
     */
    
    test('check connection management', (){
      Peer alice = new Peer("alice_ccm", llevel);
      Peer bob = new Peer("bob_ccm", llevel);
      
      //setup signaling channel
      MessagePassing alice_sc = new MessagePassing();
      MessagePassing bob_sc = new MessagePassing();
      alice_sc.connect(bob_sc.identityMap());
      bob_sc.connect(alice_sc.identityMap());
      
      
      //set callbacks
      alice.newConnectionController.stream.listen(
          expectAsync((_)=>expect(alice.connections.keys.first, bob_sc.id))
          );
      
      bob.newConnectionController.stream.listen(
          expectAsync((_)=>expect(bob.connections.keys.first, alice_sc.id))
          );
      
      //connect peer
      WebRtcDataChannel alice_c = new WebRtcDataChannel(bob_sc);
      WebRtcDataChannel bob_c = new WebRtcDataChannel(alice_sc);
      Stream<NewConnectionEvent> s_a = alice.listen(alice_c);
      Stream<NewConnectionEvent> s_b = bob.connect(bob_c);
    });
    
    
    group('multi connections', (){
      
      test('three connections at the same time', (){
        Peer alice = new Peer("alice_m3", llevel);
        Peer bob = new Peer("bob_m3", llevel);
        Peer clark = new Peer("clark_m3", llevel);
        
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
            expectAsync((_)=>expect(alice.connections.length, alice_c++), count:2)
        );
        
        bob.newConnectionController.stream.listen(
            expectAsync((_)=>expect(bob.connections.length, bob_c++), count:2)
        );
        
        clark.newConnectionController.stream.listen(
            expectAsync((_)=>expect(clark.connections.length, clark_c++), count:2)
        );
        
        //create connections
        WebRtcDataChannel a_b_c = new WebRtcDataChannel(alice_bob_sc);
        WebRtcDataChannel a_c_c = new WebRtcDataChannel(alice_clark_sc);
        
        WebRtcDataChannel b_a_c = new WebRtcDataChannel(bob_alice_sc );
        WebRtcDataChannel b_c_c = new WebRtcDataChannel(bob_clark_sc);
        
        WebRtcDataChannel c_a_c = new WebRtcDataChannel(clark_alice_sc);
        WebRtcDataChannel c_b_c = new WebRtcDataChannel(clark_bob_sc);
        
        
        //connect clark/bob bob/clark
        bob.listen(c_b_c);
        clark.connect(b_c_c);
        
        //connect alice/bob bob/alice
        alice.listen(b_a_c);
        bob.connect(a_b_c);
        
        //connect alice/clark clark/alice
        alice.listen(c_a_c);
        clark.connect(a_c_c);
      });
      
      
      
      test('3 clients send messages', (){
        logMessage("start 3 clients send messages");
        
        
        Logger.root.level = Level.ALL;
        Logger.root.onRecord.listen((LogRecord rec) {
          print('${rec.level.name}: ${rec.time}: ${rec.message}');
        });
        
        Peer alice = new Peer("alice_s3", llevel);
        Peer bob = new Peer("bob_s3", llevel);
        Peer clark = new Peer("clark_s3", llevel);
        
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
        
        String s_alice = "some random string from alice";
        String s_bob = "some random string from bob";
        String s_clark = "some random string from clark";
        Message tm_alice = new Message(s_alice);
        Message tm_bob = new Message(s_bob);
        Message tm_clark = new Message(s_clark);
        
        //each sould receive two messages
        alice.onReceive.listen(
            expectAsync((NewMessageEvent e){
              logMessage("alice received message: ${e.data.toString()}");
              
              expect(e.data.toString(), isIn([s_bob, s_clark]));
            }, count: 2)
        );

        bob.onReceive.listen(
            expectAsync((NewMessageEvent e){
              logMessage("bob received message: ${e.data.toString()}");
              
              expect(e.data.toString(), isIn([s_alice, s_clark]));
            }, count: 2)
        );
        
        
        clark.onReceive.listen(
            expectAsync((NewMessageEvent e){
              logMessage("clark received message: ${e.data.toString()}");
              
              expect(e.data.toString(), isIn([s_alice, s_bob]));
            }, count: 2)
        );
        
        /*
         * send messages
         */
        alice.newConnectionController.stream.listen((_){
          if(alice.connections.length == 2){
            logMessage("connected to exactly 2 client. looks quite good");
            
            alice.multicast(tm_alice);
          }
        });
        
        bob.newConnectionController.stream.listen((_){
          if(bob.connections.length == 2){
            logMessage("connected to exactly 2 client. looks quite good");
            
            bob.multicast(tm_bob);
          }
        });
        
        clark.newConnectionController.stream.listen((_){
          if(clark.connections.length == 2){
            logMessage("connected to exactly 2 client. looks quite good");
            
            clark.multicast(tm_clark);
          }
        });
        
        
        
        /*
         * create connections
         */
        WebRtcDataChannel a_b_c = new WebRtcDataChannel(alice_bob_sc);
        WebRtcDataChannel a_c_c = new WebRtcDataChannel(alice_clark_sc);
        
        WebRtcDataChannel b_a_c = new WebRtcDataChannel(bob_alice_sc);
        WebRtcDataChannel b_c_c = new WebRtcDataChannel(bob_clark_sc);
        
        WebRtcDataChannel c_a_c = new WebRtcDataChannel(clark_alice_sc);
        WebRtcDataChannel c_b_c = new WebRtcDataChannel(clark_bob_sc);
        
        
        //connect clark/bob bob/clark
        bob.listen(c_b_c);
        clark.connect(b_c_c);
        
        //connect alice/bob bob/alice
        alice.listen(b_a_c);
        bob.connect(a_b_c);
        
        //connect alice/clark clark/alice
        alice.listen(c_a_c);
        clark.connect(a_c_c);

      });
      
    });
    
  });
}