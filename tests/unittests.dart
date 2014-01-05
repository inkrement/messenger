library unittest;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

import 'helloworld_test.dart' as hello;
import 'jsdatachannelconnection_test.dart' as js_rtc;

import 'signaling.messagepassing_test.dart' as sig_mp;

import 'connectionstates_test.dart' as con_states;
import 'messenger_test.dart' as messenger;

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
   * libfunctions
   */
  
  group('libtests',(){
    con_states.main();
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
  
  
  /*
   * messenger
   */
  
  messenger.main();
  /// run hello world tests
  
  
  /// tests for JS Wrapper
  group('connection',(){
    js_rtc.main();
  });

  
}