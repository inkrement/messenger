import 'dart:html';
import 'package:logging/logging.dart';

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
  RtcDataChannel bob_dc;
  RtcDataChannel alice_dc;
  
  log.info("start webrtc");
  
  RtcPeerConnection alice = new RtcPeerConnection(
      {"iceServers": [{"url": "stun:stun.l.google.com:19302"}]},  
        {"optional" : [{"RtpDataChannels": true}]}
  );
  
  RtcPeerConnection bob = new RtcPeerConnection(
      {"iceServers": [{"url": "stun:stun.l.google.com:19302"}]},  
        {"optional" : [{"RtpDataChannels": true}]}
  );
  
  /*alice.onNegotiationNeeded.listen((var data){
    log.info("1# alice: onnegotiation needed");
    
    
      
    }); 
  });*/

  bob.onIceCandidate.listen((evt) {
    if (evt.candidate)
      print(evt.cancelable);
  });
  bob.onDataChannel.listen((var dc){
    log.info("#3 bob got datachannel!");
    
    bob_dc = dc.channel;
    
    log.info(bob_dc.readyState);
    
    //bob_dc.onOpen.listen((var data){
    //  log.info("bobs channel opened");
      
      bob_dc.onMessage.listen((var data){
        log.info("bob: " + data);
      });
      
      
      
      log.info("bob: send");
      dc.channel.sendString("hallo von bob");
    //});
    
  });

  alice.onIceCandidate.listen((evt) {
    if(evt.candidate != null)
      bob.addIceCandidate(evt.candidate, (){
        log.info("seems to work");
      }, (var error){
        print(error.toString());
        
      });
  });
  
  
  log.info("alice: create dc");
  
  alice_dc = alice.createDataChannel("somelablel", {"reliable": false, "protocol":"text/chat", "negotiated": null}); //fires onnegotiation needed
  
  alice_dc.onMessage.listen((var data){
    log.info("alice: received " + data);
    
    //bouce message
    alice_dc.sendString(data);
  });
  
  
  alice_dc.onOpen.listen((var data){
    log.info("alice dc opened");
    
    alice_dc.sendString("test von alice");
  });
  
  alice_dc.onClose.listen((var data){
    log.info("alice dc closed");
  });
 
  
  alice.createOffer({}).then((var sdp_alice){
    log.info('2# alice: created offer');
    //got offer
    alice.setLocalDescription(sdp_alice);
    bob.setRemoteDescription(sdp_alice);
    
    bob.createAnswer().then((RtcSessionDescription sdp_bob) {
      bob.setLocalDescription(sdp_bob);
      alice.setRemoteDescription(sdp_bob);
      
      log.info("desciptions set");
      
      
    });
  });
 
  
}
