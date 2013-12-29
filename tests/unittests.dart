
library unittest;



import 'package:unittest/html_config.dart';
//import 'dart:mirrors';
//import 'dart:async';

import 'helloworld.dart' as hello;
import 'jsrtcpeer.dart' as js_rtc;
import 'webrtcpeer.dart' as native_rtc;
import 'messagepassingpeer.dart' as messagepassing;

void main() {
  
  /// setup html environment 
  useHtmlConfiguration();
  
  
  
  /// run hello world tests
  //helloworld();
  
  /// webrtc Peer tests
  //webrtcpeer();
  
  /// tests for JS Wrapper
  js_rtc.main();
  
  /// messagepassing peer test
  //messagepassingpeer();

  
}