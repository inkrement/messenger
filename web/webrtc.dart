import 'dart:html';
import 'package:logging/logging.dart';
import "package:webrtc/Messenger/messenger.dart";

void main() {
  
  //setup logger
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
    
    var p = new ParagraphElement();
    p.appendText('${rec.level.name}: ${rec.time}: ${rec.message}');
    querySelector('#sample_container_id').append(p);
  });
  
  final Logger log = new Logger('main');
  
  
  //webrtc
  
  MessagePassingPeer alice = new MessagePassingPeer();
  
  MessagePassingPeer bob = new MessagePassingPeer();
  
  bob.onReceive.listen((NewMessageEvent data){
    log.info("bob hat Nachricht erhalten!");
  });
  
  alice.sendString(bob, "something new");
 
  
}
