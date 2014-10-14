part of messenger.exceptions;

/**
 * ChromeApiNotAvailable
 * 
 * this exception has only semantic character. 
 * It represents a failure to find Chrome's Application API.
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */

class ChromeApiNotAvailable implements Exception{
  String cause;
  ChromeApiNotAvailable(this.cause);
}