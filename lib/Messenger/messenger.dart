library messenger;

//TODO: load all

//import 'package:logging/logging.dart';

import 'src/components/peer.dart';

class Messenger{
  Peer _peer;
  Messenger _msgr;
   
  Messenger._create();
  
  factory Messenger(){
    if(_msgr == null)
      _msgr = new Messenger._create();
    
    return _msgr;
  }
}