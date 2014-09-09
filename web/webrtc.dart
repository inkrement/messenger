//import 'dart:html';

import 'package:logging/logging.dart';
import "package:messenger/messenger.dart";


/**
 * test call function to inspect js-output
 */

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
  
  print("testapp. listen. just listen");
  
  Peer alice = new Peer("alice");
  String s_alice = "some random string from alice";  
  MessengerMessage tm_alice = new MessengerMessage(s_alice);
  
  //setup signaling channels and configure connection
  ChromeAppTCPSignaling signalingChannel = new ChromeAppTCPSignaling(8756);
  
  /*
  signalingChannel.connect({
    "host":"localhost", 
    "port": 8756
    });
  */
  
  alice.onReceive.listen((NewMessageEvent mevent){
    print("alice revceived message: " + mevent.getMessage().toString());
  });
  
  //send message if connected
  alice.newConnectionController.stream.listen((_){
    if(alice.connections.length == 1){
      print('connected to some peer. now I will send something!');
      alice.multicast(tm_alice);
    }
  });
  
  
  //establish webrtc connection
  //WebRtcDataChannel webRTCChannel = new WebRtcDataChannel(signalingChannel);
  
  //Future<int> f = webRTCChannel.connect();
                  
  //f.then((int id) {
  //  alice.add(id, webRTCChannel);
  //});
}
