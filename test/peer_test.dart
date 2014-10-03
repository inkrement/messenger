library unittest.peer;

import 'package:unittest/unittest.dart';

import 'package:messenger/messenger/src/peer.dart';

void main() {
  
  group('Peer', () {

    /**
     * 1 expect to construct new Object without catching a exception
     */
    test('create new peers', (){
      Peer alice = new Peer("alice");
      Peer bob = new Peer("bob");
    });
  });
}