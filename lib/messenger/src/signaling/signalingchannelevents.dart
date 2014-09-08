/**
 * enum (class) SignalingChannelEvents
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */

part of messenger.signaling;

/**
 * some sort of enumeration
 */
class SignalingChannelEvents{
  final String name;
  final int value;
  
  static const SignalingChannelEvents CREATED = const SignalingChannelEvents._create('CREATED', 1);
  static const SignalingChannelEvents LISTENING = const SignalingChannelEvents._create('LISTENING', 2);
  static const SignalingChannelEvents NOT_ABLE_TO_LISTEN = const SignalingChannelEvents._create('NOT_ABLE_TO_LISTEN', 3);
  static const SignalingChannelEvents CONNECTED = const SignalingChannelEvents._create('CONNECTED', 4);
  static const SignalingChannelEvents NEW_INCOMING_CONNECTION = const SignalingChannelEvents._create('NEW_INCOMING_CONNECTION', 5);
  static const SignalingChannelEvents NEW_OUTGOING_CONNECTION = const SignalingChannelEvents._create('NEW_OUTGOING_CONNECTION', 6);
  
  const SignalingChannelEvents._create(this.name, this.value);
}