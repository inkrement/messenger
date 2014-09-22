/**
 * class Message
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */

library messenger.message;

import 'dart:convert';

part 'message/messagetype.dart';

class MessengerMessage{
  final String _msg;
  final MessageType _mtype;
  
  MessengerMessage(String this._msg, [MessageType this._mtype = MessageType.STRING]);
  
  String toString(){
    return _mtype.toString() + " (" + _msg + ")";
  }
  
  MessageType getMessageType() => _mtype;
  
  static Object serialize(MessengerMessage value) {
    if (value == null) return null;
    
    final Map<String, String>result = {};
    result["msg"] = value._msg;
    result["mtype"] = MessageType.serialize(value._mtype);
    
    return JSON.encode(result);
  }
  
  static MessengerMessage fromString(String data){
    if (data == null) return null;
    
    Map<String, String> json = JSON.decode(data);
    
    return new MessengerMessage(json["msg"], new MessageType.fromString(json["mtype"]));
  }
  
}

//result.nextPageToken = identity();
//result.items = map(Event.parse)(json["items"]);
//result.kind = identity(json["kind"]);

