part of messenger;

class ReadyState{
  final String name;
  final int value;
  
  //init value
  static const ReadyState NEW = const ReadyState._create('NEW', 0);
  
  //RTC
  static const ReadyState RTC_NEW = const ReadyState._create('RTC_NEW', 1);
  static const ReadyState RTC_CONNECTING = const ReadyState._create('RTC_CONNECTING', 2);
  static const ReadyState RTC_CONNECTED = const ReadyState._create('RTC_CONNECTED', 3);
  static const ReadyState RTC_COMPLETED = const ReadyState._create('RTC_COMPLETED', 4);
  static const ReadyState RTC_FAILED = const ReadyState._create('RTC_FAILED', 5);
  static const ReadyState RTC_DISCONNECTED = const ReadyState._create('RTC_DISCONNECTED', 6);
  static const ReadyState RTC_CLOSED = const ReadyState._create('RTC_CLOSED', 7);
  
  //DC
  static const ReadyState DC_CONNECTING = const ReadyState._create('DC_CONNECTING', 8);
  static const ReadyState DC_OPEN = const ReadyState._create('DC_OPEN', 9);
  static const ReadyState DC_CLOSING = const ReadyState._create('DC_CLOSING', 10);
  static const ReadyState DC_CLOSED = const ReadyState._create('DC_CLOSED', 11);
  
  //Undefined status
  static const ReadyState UNDEFINED = const ReadyState._create('UNDEFINED', 100);
  
  const ReadyState._create(this.name, this.value);
  
  factory ReadyState.fromDataChannel(String name){
    switch(name){
      case "connecting":
        return const ReadyState._create('DC_CONNECTING', 11);
      case "open":
        return const ReadyState._create('DC_OPEN', 9);
      case "closing":
        return const ReadyState._create('DC_CLOSING', 10);
      case "closed":
        return const ReadyState._create('DC_CLOSED', 11);
      default:
        return const ReadyState._create('UNDEFINED', 100);
    }
  }
}