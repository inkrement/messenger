part of messenger.connections;

class ConnectionState{
  final String name;
  final int value;
  
  //init value
  static const ConnectionState NEW = const ConnectionState._create('NEW', 0);
  
  //RTC
  static const ConnectionState RTC_NEW = const ConnectionState._create('RTC_NEW', 1);
  static const ConnectionState RTC_CONNECTING = const ConnectionState._create('RTC_CONNECTING', 2);
  static const ConnectionState RTC_CONNECTED = const ConnectionState._create('RTC_CONNECTED', 3);
  static const ConnectionState RTC_COMPLETED = const ConnectionState._create('RTC_COMPLETED', 4);
  static const ConnectionState RTC_FAILED = const ConnectionState._create('RTC_FAILED', 5);
  static const ConnectionState RTC_DISCONNECTED = const ConnectionState._create('RTC_DISCONNECTED', 6);
  static const ConnectionState RTC_CLOSED = const ConnectionState._create('RTC_CLOSED', 7);
  
  //DC
  static const ConnectionState DC_CONNECTING = const ConnectionState._create('DC_CONNECTING', 8);
  static const ConnectionState DC_OPEN = const ConnectionState._create('DC_OPEN', 9);
  static const ConnectionState DC_CLOSING = const ConnectionState._create('DC_CLOSING', 10);
  static const ConnectionState DC_CLOSED = const ConnectionState._create('DC_CLOSED', 11);
  
  //Undefined status
  static const ConnectionState UNDEFINED = const ConnectionState._create('UNDEFINED', 100);
  
  const ConnectionState._create(this.name, this.value);
  
  factory ConnectionState.fromDataChannel(String name){
    switch(name){
      case "connecting":
        return const ConnectionState._create('DC_CONNECTING', 11);
      case "open":
        return const ConnectionState._create('DC_OPEN', 9);
      case "closing":
        return const ConnectionState._create('DC_CLOSING', 10);
      case "closed":
        return const ConnectionState._create('DC_CLOSED', 11);
      default:
        return const ConnectionState._create('UNDEFINED', 100);
    }
  }
}