#!/bin/sh
pub upgrade
dart2js -c web/webrtc.dart -o web/webrtc.dart.js
