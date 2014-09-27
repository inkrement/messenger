part of messenger.exceptions;

class ChromeApiNotAvailable implements Exception{
  String cause;
  ChromeApiNotAvailable(this.cause);
}