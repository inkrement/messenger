/**
 * Connections Library
 * 
 * @author Christian Hotz-Behofsits <chris.hotz.behofsits@gmail.com>
 */

library messenger.connections;

/*
 * third party libs
 */
import 'dart:async';
export 'dart:async';
import 'package:logging/logging.dart';
import 'package:js/js.dart' as js;
import 'dart:html';

import 'package:browser_detect/browser_detect.dart';

/*
 * homebrew libs
 */
import 'signaling.dart';
export 'signaling.dart';

/*
 * load parts
 */
part 'connections/connectionstate.dart';
part 'connections/connection.dart';
part 'connections/jsdatachannelconnection.dart';
part 'connections/webrtcdatachannel.dart';