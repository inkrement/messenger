library unittest;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'connections/datachannel.dart' as rtc;
import 'signaling/messagepassing.dart' as sig_mp;
import 'connectionstates.dart' as con_states;
import 'messenger_test.dart' as messenger;

void main() {
  
  /// setup html environment 
  // override configuration to set custom timeout
  final HtmlEnhancedConfiguration sc = new HtmlEnhancedConfiguration(false);
  sc.timeout = new Duration(seconds: 3);
  unittestConfiguration = sc;
 
  
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
  
  group('connection',(){
    rtc.main();
  });

  
}