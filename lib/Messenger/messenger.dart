library messenger;

//TODO: load all

//import 'package:logging/logging.dart';


import 'src/components/peer.dart';

/**
 * test environment and return best peer
 */

class Messenger{
  final Peer _peer;
  
  const Messenger._create(this._peer);
  
  factory Messenger(){
    if(_peer == null){
      switch(testEnv()){
        case "":
        case "":
        case "":
        
      }
      //TODO: test
      return new Messenger._create(new JsWebRtcPeer());
    }
  }
  
  static String testEnv(){
    
  }
  
}