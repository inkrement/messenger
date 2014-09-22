
import 'dart:html';

import 'package:chrome/chrome_app.dart' as chrome;
import 'package:messenger/messenger.dart' as messenger;
import 'package:logging/logging.dart';


int boundsChange = 100;


/**
 * debug function to print log messages directly into the DOM
 */
void debug(String str){
  querySelector("#logs").appendHtml(new DateTime.now().toString() + " " + str + "<br/>");
}


void debug_log_msg(LogRecord r){
  print("${r.loggerName} ${r.level} ${r.message}");
}

void main() {
  debug("loading ...");
  int local_tcp_port = 37123;
  
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.loggerName}: ${rec.message}');
  });
  //Logger.root.onRecord.listen(debug_log_msg);
  
  debug("start listening on local port " + local_tcp_port.toString());
  
  
  messenger.ChromeAppTCPSignaling sc = new messenger.ChromeAppTCPSignaling(local_tcp_port);
  
  messenger.WebRtcDataChannel dc = new messenger.WebRtcDataChannel(sc);
  
  sc
  ..onEvent.listen((messenger.SignalingChannelEvents e){
    debug("new SignalingChannel event: " + e.name);
    
    switch(e){
      case messenger.SignalingChannelEvents.CONNECTED:
        break;
      case messenger.SignalingChannelEvents.LISTENING:
        uiListenOnTCPPort(sc);
        break;
      case messenger.SignalingChannelEvents.NEW_INCOMING_CONNECTION:
        uiNewTCPConnection(sc);
        dc.connect().then(initWebRTCConnection);
        break;
      case messenger.SignalingChannelEvents.NEW_OUTGOING_CONNECTION:
    }
  })
  ..onReceive.listen((messenger.NewMessageEvent e){
    debug("received: " + e.data.toString());
  });
  
  
  querySelector("#tcp_connect").onClick.listen((_){
    debug("try to connect to tcp server");
    
    //TODO: Future return-value (connect)
    dc.listen().then(initWebRTCConnection);
    sc.connect({"host":uiGetTCPHost(), "port":uiGetTCPPort().toString()});
    uiNewTCPConnection(sc);
  });
  
  querySelector("#tcp_close_button").onClick.listen((_){
      debug("close tcp connection");
      
      //FIXME: reconnection possible. but "Future already completed" error on re-closing already closed sc.
      sc.close();
      uiCloseTCP();
    });
  
}


void initWebRTCConnection(int status){
  debug("webrtc connection initated.. status: " + status.toString());
}


//
//UI Button Events and functions
//

void uiListenOnTCPPort(messenger.ChromeAppTCPSignaling sc){
  querySelector("#info").setInnerHtml("listening on port " + sc.c_port.toString());
}

void uiNewTCPConnection(messenger.ChromeAppTCPSignaling sc){
  querySelector("#tcp_connect_form").classes.add('hidden');
  querySelector("#tcp_send").classes.remove('hidden');
  querySelector("#tcp_send_button").onClick.listen((_){
    debug("send tcp message");
    
    TextAreaElement txt = querySelector("#tcp_message");
    sc.sendString(txt.value + "\n");
    txt.value = "";
  });
}

void uiCloseTCP(){
   querySelector("#tcp_connect_form").classes.remove('hidden');
   querySelector("#tcp_send").classes.add('hidden');
}


int uiGetTCPPort(){
  InputElement ie = querySelector("#localport");
  return int.parse(ie.value);
}

String uiGetTCPHost(){
  InputElement ie = querySelector("#host");
  return ie.value;
}


// app specific helpers
void resizeWindow(MouseEvent event) {
  chrome.ContentBounds bounds = chrome.app.window.current().getBounds();

  bounds.width += boundsChange;
  bounds.left -= boundsChange ~/ 2;

  chrome.app.window.current().setBounds(bounds);

  boundsChange *= -1;
}