#!/bin/bash

# Script to build Flutter web on Netlify

FLUTTER_CHANNEL=stable
FLUTTER_VERSION=3.16.0

# Install Flutter
if [ ! -d "flutter" ]; then
  echo "Downloading Flutter..."
  git clone https://github.com/flutter/flutter.git -b $FLUTTER_CHANNEL --depth 1
fi

# Add Flutter to path
export PATH="$PATH:$(pwd)/flutter/bin"

# Enable web
flutter config --enable-web

# Build frontend
echo "Building frontend..."
cd frontend
flutter pub get
flutter build web --release --dart-define=API_BASE_URL=$API_BASE_URL
cd ..

echo "Build complete!"
