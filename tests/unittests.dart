
library unittest;

import 'package:unittest/unittest.dart';
import 'package:webrtc/Messenger/messenger.dart';
import 'package:unittest/html_config.dart';
//import 'dart:mirrors';
//import 'dart:async';

part 'helloworld.dart';
part 'webrtcpeer.dart';
part 'jsrtcpeer.dart';
part 'messagepassingpeer.dart';


void main() {
  
  /// setup html environment 
  useHtmlConfiguration();
  
  /// run hello world tests
  helloworld();
  
  /// webrtc Peer tests
  //webrtcpeer();
  
  /// tests for JS Wrapper
  jsrtcpeer();
  
  /// messagepassing peer test
  //messagepassingpeer();

  
}