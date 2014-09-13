
import 'udpproxylogic.dart';
import 'udpserver.dart';

class STUNGoogleServerProxy extends UDPServer<UDPProxyLogic>{
  STUNGoogleServerProxy.local(): this._init("127.0.0.1", 19302);
  STUNGoogleServerProxy._init(String host, int port):super.init(host, port, new UDPProxyLogic("stun.l.google.com", 19302));
}