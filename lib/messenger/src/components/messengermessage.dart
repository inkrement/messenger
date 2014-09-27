/**
 * class Message
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */

library messenger.message;

import 'dart:convert';
import 'dart:html';

import 'package:logging/logging.dart';

part 'message/messagetype.dart';

class MessengerMessage{
  final String _msg;
  final MessageType _mtype;
  
  MessengerMessage(String this._msg, [MessageType this._mtype = MessageType.STRING]);
  
  String toString(){
    return _mtype.toString() + " (" + _msg + ")";
  }
  
  String getContent() => _msg;
  MessageType getMessageType() => _mtype;
  
  static String serialize(MessengerMessage value) {
    if (value == null) return null;
    
    final Map<String, String>result = {};
    result["msg"] = window.btoa(value._msg);
    result["mtype"] = MessageType.serialize(value._mtype);
    
    return JSON.encode(result);
  }
  
  static MessengerMessage deserialize(String data){
    if (data == null) return null;
    
    String base64 = window.atob(data);
    Map<String, String> json = JSON.decode(base64);
    
    return new MessengerMessage(json["msg"], new MessageType.deserialize(json["mtype"]));
  }
  
}

//result.nextPageToken = identity();
//result.items = map(Event.parse)(json["items"]);
//result.kind = identity(json["kind"]);

