library unittest.webrtcpeer;

import 'package:unittest/unittest.dart';
import 'package:webrtc/Messenger/messenger.dart';

void main() {
  
  
  /**
   * expect to construct new Object without catching a exception
   */
  test('Webrtc Status', (){
    WebRtcPeer alice = new WebRtcPeer();
    WebRtcPeer bob = new WebRtcPeer();
  });
  
  /**
   * The type od a new rtcPeerConnection should be
   * RTCPeerConnection
   */
  test('Webrtc types peerconnection',(){
    WebRtcPeer alice = new WebRtcPeer();

    //expect(alice.rtcPeerConnection.toString(), 'RtcPeerConnection');
  });
  
  
  /**
   * New Peer should not have a datachannel.
   * Therefore readyState is initialized with "none"
   */
  test('Webrtc datachannel status',(){
    WebRtcPeer alice = new WebRtcPeer();

    expect(alice.readyState, "none");
  });
  
  /**
   * Test Connection
   */
  test('Webrtc connect',(){
    WebRtcPeer alice = new WebRtcPeer("alice");
    WebRtcPeer bob = new WebRtcPeer("bob");
    
    alice.connect(bob);
  });
  
  
  
  
  /*
  test('Webrtc types datachannel',(){
    JsWebRtcPeer alice = new JsWebRtcPeer();
    
    InstanceMirror myClassInstanceMirror = reflect(alice);
    //String type = myClassInstanceMirror.type;
    //logMessage();
    
    
    //expect("", myClassInstanceMirror.type);
  });
  
  test('Webrtc has icecandidates',(){
    JsWebRtcPeer alice = new JsWebRtcPeer();
    JsWebRtcPeer bob = new JsWebRtcPeer();
    
    //expect(alice.connect(bob), completes);
   
  });
  
  
  test("testing a future", () {
    Compute compute = new Compute();    
    Future<Map> future = compute.sumIt([1, 2, 3]);
    expect(future, completion(equals({"value" : 6})));
  });
  */
  
  
  //test connect
  

  
  
}