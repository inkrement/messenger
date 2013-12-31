library messenger.message;

import 'package:utils/utils.dart';

class Message{
  final String msg;
  final MessageType mtype;
  
  Message(String this.msg, [MessageType this.mtype = MessageType.STRING]);
  
  
  String toString(){
    return msg;
  }
  
  MessageType getMessageType() => mtype;
  
  static Object serialize(Message value) {
    if (value == null) return null;
    final result = {};
    result["nextPageToken"] = identity(value.nextPageToken);
    
    result["kind"] = identity(value.kind);
    
    //list
    result["items"] = map(Message.serialize)(value.items);
    return result;
  }
  
}


/**
 * some sort of enumeration
 */
class MessageType extends IdentityHash{
  final String name;
  final int value;
  
  static const MessageType STRING = const MessageType('STRING', 1);
  static const MessageType SERIALIZED = const MessageType('SERIALIZED', 2);
  static const MessageType SIGNAL = const MessageType('SIGNAL', 3);
  static const MessageType UNDEFINED = const MessageType('UNDEFINED', 4);
  static const MessageType ICE_CANDIDATE = const MessageType('ICE_CANDIDATE', 5);
  static const MessageType WEBRTC_OFFER = const MessageType('WEBRTC_OFFER', 6);
  static const MessageType WEBRTC_ANSWER = const MessageType('WEBRTC_ANSWER', 7);
  
  static const MessageType PEER_ID = const MessageType('PEER_ID', 8);
  
  const MessageType(this.name, this.value);
  
  static Object serialize(MessageType value) {
    if (value == null) return null;
    final result = {};
    result["name"] = identity(value.nextPageToken);
    
    result["value"] = identity(value.kind);
    
    //list
    result["items"] = map(Message.serialize)(value.items);
    return result;
  }
}