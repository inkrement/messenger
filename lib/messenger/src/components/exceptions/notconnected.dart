part of messenger.exceptions;

/**
 * BadConnectionState
 * 
 * this exception has only semantic character. 
 * It represents a missing network connection.
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */

class NotConnected implements Exception{
  String cause;
  NotConnected(this.cause);
}