library messenger.message;

import 'dart:convert';

part 'message/messagetype.dart';

class Message{
  final String _msg;
  final MessageType _mtype;
  
  Message(String this._msg, [MessageType this._mtype = MessageType.STRING]);
  
  
  String toString(){
    return _msg;
  }
  
  MessageType getMessageType() => _mtype;
  
  static Object serialize(Message value) {
    if (value == null) return null;
    
    final Map<String, String>result = {};
    result["msg"] = value._msg;
    result["mtype"] = MessageType.serialize(value._mtype);
    
    return JSON.encode(result);
  }
  
  factory Message.fromString(String data){
    if (data == null) return null;
    
    Map<String, String> json = JSON.decode(data);
    
    return new Message(json["msg"], new MessageType.fromString(json["mtype"]));
  }
  
}

//result.nextPageToken = identity();
//result.items = map(Event.parse)(json["items"]);
//result.kind = identity(json["kind"]);

