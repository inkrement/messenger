library messenger;

import 'src/peer.dart';
export 'src/peer.dart';

Peer peer;

main(){
  
  peer = new Peer();
  
  //connect receive to stdout
  peer.onReceive.listen((msg){
    
  });
}


/*
 * JS callback hooks
 */

void send(String msg){
  
}
