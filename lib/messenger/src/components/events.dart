/**
 * Custom Event Libraray
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */

library messenger.events;

import 'dart:html';
import 'messengermessage.dart';
export 'messengermessage.dart';

//only import connection class
import '../connections.dart';

part 'events/newmessageevent.dart';
part 'events/newconnectionevent.dart';
