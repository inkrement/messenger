
library unittest;



import 'package:unittest/html_config.dart';
//import 'dart:mirrors';
//import 'dart:async';

import 'helloworld.dart' as hello;
import 'jsrtcpeer.dart' as js_rtc;
import 'webrtcpeer.dart' as native_rtc;
import 'messagepassingpeer.dart' as messagepassing;

import 'signaling.messagepassing.dart' as sig_mp;

void main() {
  
  /// setup html environment 
  useHtmlConfiguration();
  
  /*
   * signaling
   */
  
  //sig_mp.main();
  
  /*
   * peers
   */
  
  /// tests for JS Wrapper
  js_rtc.main();
  
  /// run hello world tests
  //helloworld();
  
  /// webrtc Peer tests
  //webrtcpeer();
  
  
  
  /// messagepassing peer test
  //messagepassingpeer();

  
}