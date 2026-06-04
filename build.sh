#!/bin/bash

# Script de construcción para Render
set -e # Detener si hay error

FLUTTER_CHANNEL=stable

# 1. Instalar Flutter si no existe
if [ ! -d "flutter" ]; then
  echo "Descargando Flutter..."
  git clone https://github.com/flutter/flutter.git -b $FLUTTER_CHANNEL --depth 1
fi

# 2. Configurar el Path
export PATH="$PATH:$(pwd)/flutter/bin"

# 3. Limpiar y preparar
flutter config --enable-web
cd frontend
flutter clean
flutter pub get

# 4. Compilar para Web con renderer HTML (más compatible)
echo "Compilando frontend..."
flutter build web --release --web-renderer html --dart-define=API_BASE_URL=$API_BASE_URL

echo "Compilación completada con éxito."
cd ..
