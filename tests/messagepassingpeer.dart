part of unittest;

messagepassingpeer() {
  test('SendAndReceive', (){
    MessagePassingPeer alice = new MessagePassingPeer();
    MessagePassingPeer bob = new MessagePassingPeer();
    
    bob.onReceive.listen((NewMessageEvent data){
      expect(data.getMessage(), "something new");
    });
    
    alice.sendString(bob, "something new");
  });
}