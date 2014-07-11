library messenger;

import 'messenger/src/peer.dart';
export 'messenger/src/peer.dart';

class Messenger{
  static final Peer _peer = new Peer("local peer");
  static final Messenger _msgr=new Messenger._init();
  
  Messenger._init();
  
  factory Messenger(){
    return _msgr;
  }
}