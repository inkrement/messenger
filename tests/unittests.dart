library unittest;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

import 'helloworld_test.dart' as hello;
import 'jswebrtcconnection_test.dart' as js_rtc;

import 'signaling.messagepassing_test.dart' as sig_mp;

void main() {
  
  /// setup html environment 
  // override configuration to set custom timeout
  final HtmlEnhancedConfiguration sc = new HtmlEnhancedConfiguration(false);
  sc.timeout = new Duration(seconds: 10);
  unittestConfiguration = sc;
  
  /*
   * test
   */
  hello.main();
  
  /*
   * signaling
   */
  
  sig_mp.main();
  
  /*
   * peers
   */
  
  /// run hello world tests
  
  
  /// tests for JS Wrapper
  js_rtc.main();
  

  
  /// webrtc Peer tests
  //webrtcpeer();
  
  
  
  /// messagepassing peer test
  //messagepassing.main();

  
}