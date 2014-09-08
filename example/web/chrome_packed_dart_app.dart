
import 'dart:html';

import 'package:chrome/chrome_app.dart' as chrome;
import 'package:messenger/messenger.dart' as messenger;


int boundsChange = 100;


/**
 * debug function to print log messages directly into the DOM
 */
void debug(String str){
  querySelector("#logs").appendHtml(new DateTime.now().toString() + " " + str + "<br/>");
}


void main() {
  debug("loading ...");
  int local_tcp_port = 37123;
  
  
  debug("start listening on local port " + local_tcp_port.toString());
  
  
  messenger.ChromeAppTCPSignaling sc = new messenger.ChromeAppTCPSignaling(local_tcp_port);
  
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
        break;
      case messenger.SignalingChannelEvents.NEW_OUTGOING_CONNECTION:
    }
  })
  ..onReceive.listen((messenger.NewMessageEvent e){
    debug("received: " + e.data.toString());
  });
 
  //messenger.WebRtcDataChannel
}




//UI Button Events and functions

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

 /**
  * host should be "127.0.0.1" - localhost will not work until it's enabled by Manifest
  */
void uiConnectToTCP(messenger.SignalingChannel sc, String host, String port){
  sc.connect({"host":host, "port":port});
}




// app specific helpers
void resizeWindow(MouseEvent event) {
  chrome.ContentBounds bounds = chrome.app.window.current().getBounds();

  bounds.width += boundsChange;
  bounds.left -= boundsChange ~/ 2;

  chrome.app.window.current().setBounds(bounds);

  boundsChange *= -1;
}