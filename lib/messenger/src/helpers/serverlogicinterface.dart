
library messenger.helpers;

import 'dart:async';

abstract class ServerLogicInterface<T>{
  T _state;
  
  Future<String> response(String request);
}