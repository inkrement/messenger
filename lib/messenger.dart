library messenger;

import 'messenger/src/peer.dart';
export 'messenger/src/peer.dart';

class Messenger{
  static final Peer _peer = new Peer("local peer");
  static Messenger _msgr;
  
  Messenger._init();
  
  factory Messenger(){
    if (_msgr == null) _msgr=new Messenger._init();
    return _msgr;
  }
}