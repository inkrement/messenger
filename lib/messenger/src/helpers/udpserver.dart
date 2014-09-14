import 'serverlogicinterface.dart';

import 'package:chrome/chrome_app.dart' as chrome;
import 'dart:convert';

class UDPServer<T extends ServerLogicInterface>{
  final T _logic;
  int _socketId;
  
    UDPServer.init(String host, int port, T logic):_logic=logic{
      
      // TODO: listen and repeat ;)
      chrome.sockets.udp.create().then((chrome.CreateInfo info){
            this._socketId = info.socketId;
            
            chrome.sockets.udp.onReceive.listen((chrome.ReceiveInfo data){
              if (data.socketId == this._socketId)
                _logic.response(data.data.toString()).then((String response) => sendString(data, response));
              
              
                
                //send data.data
            }).onError((Error e) {});
            
            chrome.sockets.udp.bind(this._socketId, host, port).then((int result){
              if(result < 0)
                print("error");
              
            }).catchError((Error e) {});
          }).catchError((Error e) {});
    }
    
    void sendString(chrome.ReceiveInfo remoteInfo, String message){
      
      //TODO: get remote address and port. check which socket id to use
     // chrome.sockets.udp.send(remoteInfo.socketId, new chrome.ArrayBuffer.fromBytes(UTF8.encode(message)), 
      //    remoteInfo, this.port).then((chrome.SendInfo info){
     // }).catchError((Error e) {});
    }
}