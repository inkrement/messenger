/**
 * test creation of different connection states
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */


library unittest.connectionstates;

import 'package:unittest/unittest.dart';
import 'package:webrtc/Messenger/src/connections.dart';


void main(){
  
  group('ConnectionState Factories', (){
    
    test('RTCSignalingState', (){
      expect(new ConnectionState.fromRTCSignalingState(""), ConnectionState.ERROR);
      expect(new ConnectionState.fromRTCSignalingState("something"), ConnectionState.ERROR);
      
      expect(new ConnectionState.fromRTCSignalingState("have-local-offer"), ConnectionState.CONNECTING);
      expect(new ConnectionState.fromRTCSignalingState("have-remote-offer"), ConnectionState.CONNECTING);
      expect(new ConnectionState.fromRTCSignalingState("have-local-pranswer"), ConnectionState.CONNECTING);
      expect(new ConnectionState.fromRTCSignalingState("have-remote-pranswer"), ConnectionState.CONNECTING);
      
      expect(new ConnectionState.fromRTCSignalingState("stable"), ConnectionState.NEW);
      expect(new ConnectionState.fromRTCSignalingState("closed"), ConnectionState.CLOSED);
    });
    
    test('RTCIceConnectionState', (){
      expect(new ConnectionState.fromRTCIceConnectionState(""), ConnectionState.ERROR);
      expect(new ConnectionState.fromRTCIceConnectionState("something"), ConnectionState.ERROR);
      
      expect(new ConnectionState.fromRTCIceConnectionState("new"), ConnectionState.PREPARE_CONNECTING);
      expect(new ConnectionState.fromRTCIceConnectionState("checking"), ConnectionState.PREPARE_CONNECTING);
      expect(new ConnectionState.fromRTCIceConnectionState("connected"), ConnectionState.PREPARE_CONNECTING);
      expect(new ConnectionState.fromRTCIceConnectionState("completed"), ConnectionState.PREPARE_CONNECTING);
      expect(new ConnectionState.fromRTCIceConnectionState("failed"), ConnectionState.PREPARE_CONNECTING);
      expect(new ConnectionState.fromRTCIceConnectionState("disconnected"), ConnectionState.PREPARE_CONNECTING);
      expect(new ConnectionState.fromRTCIceConnectionState("closed"), ConnectionState.PREPARE_CONNECTING);
    });
    
    
    test('RTCIceGatheringState', (){
      expect(new ConnectionState.fromRTCIceGatheringState(""), ConnectionState.ERROR);
      expect(new ConnectionState.fromRTCIceGatheringState("something"), ConnectionState.ERROR);
      
      expect(new ConnectionState.fromRTCIceGatheringState("new"), ConnectionState.PREPARE_CONNECTING);
      expect(new ConnectionState.fromRTCIceGatheringState("gathering"), ConnectionState.PREPARE_CONNECTING);
      expect(new ConnectionState.fromRTCIceGatheringState("complete"), ConnectionState.CONNECTING);
    });
    
    
    test('RTCDataChannelState', (){
      expect(new ConnectionState.fromRTCDataChannelState(""), ConnectionState.ERROR);
      expect(new ConnectionState.fromRTCDataChannelState("something"), ConnectionState.ERROR);
      
      expect(new ConnectionState.fromRTCDataChannelState("connecting"), ConnectionState.CONNECTING);
      expect(new ConnectionState.fromRTCDataChannelState("open"), ConnectionState.CONNECTED);
      expect(new ConnectionState.fromRTCDataChannelState("closed"), ConnectionState.CLOSED);
      expect(new ConnectionState.fromRTCDataChannelState("closing"), ConnectionState.CLOSING);
    });
    
  });
  
}