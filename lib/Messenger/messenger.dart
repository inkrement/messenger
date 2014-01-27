library messenger;

import 'src/peer.dart';
export 'src/peer.dart';

class Messenger{
  Peer _peer;
  static Messenger _msgr;
   
  Messenger._create();
  
  factory Messenger(){
    if(_msgr == null)
      _msgr = new Messenger._create();
    
    return _msgr;
  }
}