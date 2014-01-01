library unittest.helloworld;

import 'package:unittest/unittest.dart';

main() {
  
  group('Simple Unittests to check Framework', () {
  
    /**
     * hello world
     */
    test('hello world', (){
      String hello = "hello world";
      
      expect(hello, "hello world");
    });
  });
}