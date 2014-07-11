/**
 * ConnectionState
 * 
 * states:
 *  NEW: Connection is new
 *  CONNECTING: Connection is currently connecting. Messages will be piped
 *  CONNECTED: Connection is usable. 
 *  CLOSING: connection is closing
 *  ERROR: Connection is not usable. 
 *  CLOSED: Connection is closed.
 *  
 *  @ TODO: rename class
 *  
 *  @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */

part of messenger.connections;

class ConnectionState{
  final String name;
  final int value;
  
  //init value
  static const ConnectionState NEW = const ConnectionState._create('NEW', 0);
  static const ConnectionState PREPARE_CONNECTING = const ConnectionState._create('PREPARE_CONNECTING', 10);
  static const ConnectionState CONNECTING = const ConnectionState._create('CONNECTING', 11);
  static const ConnectionState CONNECTED = const ConnectionState._create('CONNECTED', 12);
  static const ConnectionState CLOSING = const ConnectionState._create('CLOSING', 20);
  static const ConnectionState CLOSED = const ConnectionState._create('CLOSED', 21);
  static const ConnectionState ERROR = const ConnectionState._create('ERROR', 30);
  
  const ConnectionState._create(this.name, this.value);
  
  /**
   * <Factory> fromRTCSignalingState
   * 
   * enum RTCSignalingState {
   * "stable",
   * "have-local-offer",
   * "have-remote-offer",
   * "have-local-pranswer",
   * "have-remote-pranswer",
   * "closed"
   * };
   * 
   * @return ConnectionState
   */
  
  factory ConnectionState.fromRTCSignalingState(String name){
    switch(name){
      case "stable":
        return ConnectionState.NEW;
      case "have-local-offer":
        return ConnectionState.CONNECTING;
      case "have-remote-offer":
        return ConnectionState.CONNECTING;
      case "have-local-pranswer":
        return ConnectionState.CONNECTING;
      case "have-remote-pranswer":
        return ConnectionState.CONNECTING;
      case "closed":
        return ConnectionState.CLOSED;
        
      default:
        return ConnectionState.ERROR;
    }
  }
  
  
  /**
   * <Factory> fromRTCIceConnectionState
   * 
   * enum RTCIceConnectionState {
   * "new",
   * "checking",
   * "connected",
   * "completed",
   * "failed",
   * "disconnected",
   * "closed"
   * };
   * 
   * @return ConnectionState
   */
  
  factory ConnectionState.fromRTCIceConnectionState(String name){
    switch(name){
      case "new":
        return ConnectionState.PREPARE_CONNECTING;
      case "checking":
        return ConnectionState.PREPARE_CONNECTING;
      case "connected":
        return ConnectionState.PREPARE_CONNECTING;
      case "completed":
        return ConnectionState.PREPARE_CONNECTING;
      case "failed":
        return ConnectionState.PREPARE_CONNECTING;
      case "disconnected":
        return ConnectionState.PREPARE_CONNECTING;
      case "closed":
        return ConnectionState.PREPARE_CONNECTING;
        
      default:
        return ConnectionState.ERROR;
    }
  }
  
  
  
  /**
   * <Factory> fromRTCIceGatheringState
   * 
   * enum RTCIceGatheringState {
   * "new",
   * "gathering",
   * "complete"
   * };
   * 
   * @return ConnectionState
   */
  
  factory ConnectionState.fromRTCIceGatheringState(String name){
    switch(name){
      case "new":
        return ConnectionState.PREPARE_CONNECTING;
      case "gathering":
        return ConnectionState.PREPARE_CONNECTING;
      case "complete":
        return ConnectionState.CONNECTING;
        
      default:
        return ConnectionState.ERROR;
    }
  }
  
  
  
  /**
   * <Factory> fromRTCDataChannelState
   * 
   * create Ready State from DataChannel readyState
   * 
   * enum RTCDataChannelState {
   * "connecting",
   * "open",
   * "closing",
   * "closed"
   * };
   * 
   * @return ConnectionState
   */
  
  factory ConnectionState.fromRTCDataChannelState(String name){
    switch(name){
      case "connecting":
        return ConnectionState.CONNECTING;
      case "open":
        return ConnectionState.CONNECTED;
      case "closing":
        return ConnectionState.CLOSING;
      case "closed":
        return ConnectionState.CLOSED;
        
      default:
        return ConnectionState.ERROR;
    }
  }
}