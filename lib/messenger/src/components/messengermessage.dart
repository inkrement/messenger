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
  static final Logger _log = new Logger("MessengerMessage");
  
  MessengerMessage(String this._msg, [MessageType this._mtype = MessageType.STRING]);
  
  String toString(){
    return _mtype.toString() + " (" + _msg + ")";
  }
  
  String getContent() => _msg;
  MessageType getMessageType() => _mtype;
  
  static String serialize(MessengerMessage value) {
    if (value == null) return null;
    
    final Map<String, String>result = {};
    result["msg"] = value._msg;//window.btoa(value._msg);
    result["mtype"] = MessageType.serialize(value._mtype);
    
    String json = JSON.encode(result);
    
    _log.finest("serialize:" + value.toString() + "to:" + json);
    
    return json;
  }
  
  static MessengerMessage deserialize(String data){
    if (data == null) return null;
    
    _log.finest("deserializer: " + data);
    
    Map<String, String> json = JSON.decode(data);
    //String base64_msg = window.atob(json["msg"]);
    String msg = json["msg"];
    
    return new MessengerMessage(msg, MessageType.deserialize(json["mtype"]));
  }
  
}