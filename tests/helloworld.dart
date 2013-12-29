library unittest.helloworld;

import 'package:unittest/unittest.dart';

main() {
  
  /**
   * hello world
   */
  test('hello world', (){
    String hello = "hello world";
    
    expect(hello, "hello world");
  });
}