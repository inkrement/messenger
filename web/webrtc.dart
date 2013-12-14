import 'dart:html';
import 'package:logging/logging.dart';
//import 'lib/peer.dart';
import "package:webrtc/peer.dart";

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
  
  Peer alice = new MessagePassingPeer();

 
  
}
