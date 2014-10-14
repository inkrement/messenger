part of messenger.exceptions;

/**
 * BadConfiguration
 * 
 * this exception has only semantic character.
 * It represents a configuration failure.
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */

class BadConfiguration implements Exception{
  String cause;
  BadConfiguration(this.cause);
}