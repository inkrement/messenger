#!/bin/sh
pub upgrade
dart2js -c --csp web/webrtc.dart -o web/webrtc.dart.js
