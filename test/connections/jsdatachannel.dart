library unittest.jsrtcpeer;

import 'package:unittest/unittest.dart';
import 'package:logging/logging.dart';

import 'package:WebRTCMessenger/WebRTCMessenger/src/peer.dart';

void main() {
  
  group('Jswebrtc Connection', () {
    
    
    /**
     * 2 The type od a new rtcPeerConnection should be
     * RTCPeerConnection
     */
    test('JSWebrtc create components',(){
      Peer alice = new Peer("alice", Level.OFF);
      MessagePassing alice_sc = new MessagePassing();
      JsDataChannelConnection alice_cn = new JsDataChannelConnection(alice_sc);
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
      JsDataChannelConnection alice_c = new JsDataChannelConnection(bob_sc);
      JsDataChannelConnection bob_c = new JsDataChannelConnection(alice_sc);
      Stream<NewConnectionEvent> s_a = alice.listen(alice_c);
      Stream<NewConnectionEvent> s_b = bob.connect(bob_c);
      
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
      JsDataChannelConnection alice_c = new JsDataChannelConnection(bob_sc);
      JsDataChannelConnection bob_c = new JsDataChannelConnection(alice_sc);
      Stream<NewConnectionEvent> s_a = alice.listen(alice_c);
      Stream<NewConnectionEvent> s_b = bob.connect(bob_c);
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
      JsDataChannelConnection alice_c = new JsDataChannelConnection(bob_sc);
      JsDataChannelConnection bob_c = new JsDataChannelConnection(alice_sc);
      Stream<NewConnectionEvent> s_a = alice.listen(alice_c);
      Stream<NewConnectionEvent> s_b = bob.connect(bob_c);
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
        
        //create connections
        JsDataChannelConnection a_b_c = new JsDataChannelConnection(alice_bob_sc);
        JsDataChannelConnection a_c_c = new JsDataChannelConnection(alice_clark_sc);
        
        JsDataChannelConnection b_a_c = new JsDataChannelConnection(bob_alice_sc );
        JsDataChannelConnection b_c_c = new JsDataChannelConnection(bob_clark_sc);
        
        JsDataChannelConnection c_a_c = new JsDataChannelConnection(clark_alice_sc);
        JsDataChannelConnection c_b_c = new JsDataChannelConnection(clark_bob_sc);
        
        
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
        
        String s_alice = "some random string from alice";
        String s_bob = "some random string from bob";
        String s_clark = "some random string from clark";
        Message tm_alice = new Message(s_alice);
        Message tm_bob = new Message(s_bob);
        Message tm_clark = new Message(s_clark);
        
        //each sould receive two messages
        alice.onReceive.listen(
            expectAsync1((NewMessageEvent e){
              logMessage("alice received message: ${e.data.toString()}");
              
              expect(e.data.toString(), isIn([s_bob, s_clark]));
            }, count: 2)
        );

        bob.onReceive.listen(
            expectAsync1((NewMessageEvent e){
              logMessage("bob received message: ${e.data.toString()}");
              
              expect(e.data.toString(), isIn([s_alice, s_clark]));
            }, count: 2)
        );
        
        
        clark.onReceive.listen(
            expectAsync1((NewMessageEvent e){
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
        JsDataChannelConnection a_b_c = new JsDataChannelConnection(alice_bob_sc);
        JsDataChannelConnection a_c_c = new JsDataChannelConnection(alice_clark_sc);
        
        JsDataChannelConnection b_a_c = new JsDataChannelConnection(bob_alice_sc);
        JsDataChannelConnection b_c_c = new JsDataChannelConnection(bob_clark_sc);
        
        JsDataChannelConnection c_a_c = new JsDataChannelConnection(clark_alice_sc);
        JsDataChannelConnection c_b_c = new JsDataChannelConnection(clark_bob_sc);
        
        
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