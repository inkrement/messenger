/**
 * Utilities for direct signaling
 */

library signaling;

/**
 * Error thrown by JSON serialization if an object cannot be serialized.
 *
 * The [unsupportedObject] field holds that object that failed to be serialized.
 *
 * If an object isn't directly serializable, the serializer calls the 'toJson'
 * method on the object. If that call fails, the error will be stored in the
 * [cause] field. If the call returns an object that isn't directly
 * serializable, the [cause] will be null.
 */
class SignalingCouldNotFindHost extends Error {
  /** The object that could not be serialized. */
  final unsupportedObject;
  /** The exception thrown by object's [:toJson:] method, if any. */
  final cause;

  SignalingCouldNotFindHost(this.unsupportedObject, { this.cause });

  String toString() {
    if (cause != null) {
      return "Calling toJson method on object failed.";
    } else {
      return "Object toJson method returns non-serializable value.";
    }
  }
}

/**
 * inteface signaling Channel
 */
abstract class SignalChannel {
  open();
  close();
  send();
  receive();
}
