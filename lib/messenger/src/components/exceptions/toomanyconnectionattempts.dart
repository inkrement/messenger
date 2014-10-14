part of messenger.exceptions;

/**
 * TooManyConnectionAttempts
 * 
 * this exception has only semantic character. 
 * It represents the failure of to many failed connection attempts.
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */

class TooManyConnectionAttempts implements Exception{
  String cause;
  TooManyConnectionAttempts(this.cause);
}