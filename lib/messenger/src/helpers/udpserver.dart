import 'serverlogicinterface.dart';

class UDPServer<T extends ServerLogicInterface>{
  final T _logic;
  
    UDPServer.init(String host, int port, T logic):_logic=logic{
      
      // TODO: listen and repeat ;)
      
    }
}