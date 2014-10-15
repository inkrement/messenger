part of messenger.exceptions;

/**
 * BadConnectionState
 * 
 * this exception has only semantic character. 
 * It represents several bad connection states.
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */

class BadConnectionState implements Exception{
  String cause;
  BadConnectionState(this.cause);
}