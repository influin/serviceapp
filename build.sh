#!/bin/bash
# Download and setup Dart SDK
curl -L https://storage.googleapis.com/dart-archive/channels/stable/release/3.7.2/sdk/dartsdk-linux-x64-release.zip -o dart.zip
unzip dart.zip
export PATH="$PATH:`pwd`/dart-sdk/bin"

# Download and setup Flutter
curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.9-stable.tar.xz | tar -xJ
export PATH="$PATH:`pwd`/flutter/bin"

# Build the web app
flutter precache
flutter build web --release --base-href /