part of messenger.exceptions;

class BadConnectionState implements Exception{
  String cause;
  BadConnectionState(this.cause);
}