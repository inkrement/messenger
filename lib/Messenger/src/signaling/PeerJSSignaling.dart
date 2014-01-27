/**
 * 
 */

part of messenger.signaling;

class PeerJsSignaling extends SignalingChannel{
  
  Factory getNewID(){

  }
  
  
  /**
   * connect
   * 
   * Map key is the name of the SignalingChannel.
   * @ TODO: add custom Exceptions
   *  * prevent self-connections
   */
  Future connect(Map<String, String> options){
    if(options.isEmpty)
      throw new StateError("empty option set excatly one value expected. none found!");
    
    if(!browser.isChrome)
      throw new StateError("only available in chrome!");
    
    var url = "http://127.0.0.1:8080/programming-languages";

    // call the web server asynchronously
    var request = HttpRequest.getString(url).then(onDataLoaded);
    
  }
  
  /**
   * send message
   * 
   * creates new message and sends it to 
   * the other MessagePassing object
   */
  send(Message message){
    
  }
  
  /**
   * close
   */
  close(){
    
    
    connection_completer.complete("connection closed");
  }
  
  /**
   * identityMap
   * 
   * returns a map with a reference to this object
   */
  
  Map<String, String> identityMap(){
    
    return {this.hashCode: this};
  }
  
}