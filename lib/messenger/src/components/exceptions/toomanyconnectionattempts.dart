

part of messenger.exceptions;

class TooManyConnectionAttempts implements Exception{
  String cause;
  TooManyConnectionAttempts(this.cause);
}