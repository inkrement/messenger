part of messenger.exceptions;

class BadConfiguration implements Exception{
  String cause;
  BadConfiguration(this.cause);
}