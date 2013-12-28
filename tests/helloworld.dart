part of unittest;

void helloworld() {
  
  /**
   * hello world
   */
  test('hello world', (){
    String hello = "hello world";
    
    expect(hello, "hello world");
  });
}