#!/bin/bash

# Install specific version of Dart SDK (3.7.2)
curl -L https://storage.googleapis.com/dart-archive/channels/stable/release/3.7.2/sdk/dartsdk-linux-x64-release.zip -o dart.zip
unzip dart.zip
export PATH="$PATH:`pwd`/dart-sdk/bin"

# Verify Dart version
dart --version

# Download and setup Flutter
curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.9-stable.tar.xz | tar -xJ
export PATH="$PATH:`pwd`/flutter/bin"

# Configure Flutter to use the installed Dart SDK
export FLUTTER_ROOT=`pwd`/flutter
export DART_SDK=`pwd`/dart-sdk

# Build the web app
flutter doctor
flutter config --no-analytics
flutter pub get
flutter build web --release --base-href /