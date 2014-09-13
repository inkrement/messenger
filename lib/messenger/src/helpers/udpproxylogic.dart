
library messenger.helpers;

import 'serverlogicinterface.dart';
import 'dart:convert';
import 'package:chrome/chrome_app.dart' as chrome;
import 'dart:async';

class UDPProxyLogic implements ServerLogicInterface<String>{
  int _socketId;
  int _port;
  String _host;
  
  UDPProxyLogic(String host, int port){
    this._host = host;
    this._port = port;
  }
  
  /**
   * redirect response from remote UDP service
   */
  Future<String> response(String request){
    Completer<String> c = new Completer<String>();
    
    chrome.sockets.udp.create().then((chrome.CreateInfo info){
      this._socketId = info.socketId;
      
      chrome.sockets.udp.onReceive.listen((chrome.ReceiveInfo data){
        if (data.socketId == this._socketId){
          c.complete(data.data.toString());
          chrome.sockets.udp.close(this._socketId); 
        }
      }).onError((Error e) => c.completeError(e));
      
      chrome.sockets.udp.bind(this._socketId, '0.0.0.0', 0).then((int result){
        if(result < 0)
          print("error");
        
        chrome.sockets.udp.send(this._socketId, new chrome.ArrayBuffer.fromBytes(UTF8.encode(request)), 
            this._host, this._port).then((chrome.SendInfo info){
        }).catchError((Error e) => c.completeError(e));
        
      }).catchError((Error e) => c.completeError(e));
    }).catchError((Error e) => c.completeError(e));
    
    
    return c.future;
  } 
}