library unittest;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

import 'helloworld_test.dart' as hello;
import 'jsdatachannelconnection_test.dart' as js_rtc;

import 'signaling.messagepassing_test.dart' as sig_mp;

void main() {
  
  /// setup html environment 
  // override configuration to set custom timeout
  final HtmlEnhancedConfiguration sc = new HtmlEnhancedConfiguration(false);
  sc.timeout = new Duration(seconds: 3);
  unittestConfiguration = sc;
  
  /*
   * test
   */
  group('selftest',(){
    hello.main();
  });
  
  /*
   * signaling
   */
  
  group('signaling',(){
    sig_mp.main();
  });
  
  
  /*
   * peer
   */
  
  /// run hello world tests
  
  
  /// tests for JS Wrapper
  group('connection',(){
    js_rtc.main();
  });

  
}