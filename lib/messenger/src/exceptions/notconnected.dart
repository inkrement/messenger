part of messenger.exceptions;

class NotConnected implements Exception{
  String cause;
  NotConnected(this.cause);
}