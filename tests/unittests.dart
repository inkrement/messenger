
library unittest;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

import 'helloworld.dart' as hello;
import 'jsrtcpeer.dart' as js_rtc;
import 'webrtcpeer.dart' as native_rtc;
import 'messagepassingpeer.dart' as messagepassing;

import 'signaling.messagepassing.dart' as sig_mp;

void main() {
  
  /// setup html environment 
  // override configuration to set custom timeout
  final HtmlEnhancedConfiguration sc = new HtmlEnhancedConfiguration(false);
  sc.timeout = new Duration(seconds: 5);
  unittestConfiguration = sc;
  
  /*
   * signaling
   */
  
  //sig_mp.main();
  
  /*
   * peers
   */
  
  /// run hello world tests
  hello.main();
  
  /// tests for JS Wrapper
  js_rtc.main();
  

  
  /// webrtc Peer tests
  //webrtcpeer();
  
  
  
  /// messagepassing peer test
  //messagepassing.main();

  
}