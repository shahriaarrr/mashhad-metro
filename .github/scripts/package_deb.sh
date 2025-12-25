#!/usr/bin/env bash
set -euo pipefail

# Usage: package_deb.sh <tag>
TAG=${1:-dev}
# strip leading 'v' if present
VERSION="${TAG#v}"
# binary name (from pubspec.yaml: name: mashhad_metro)
PKG_NAME="mashhad_metro"
BUILD_DIR="build/${PKG_NAME}-${VERSION}-deb"
ARCH_DIR="$BUILD_DIR/usr/bin"
ICON_DIR="$BUILD_DIR/usr/share/icons/hicolor/128x128/apps"
DESKTOP_DIR="$BUILD_DIR/usr/share/applications"

echo "Packaging DEB for $PKG_NAME version $VERSION"

rm -rf "$BUILD_DIR"
mkdir -p "$ARCH_DIR"
mkdir -p "$ICON_DIR"
mkdir -p "$DESKTOP_DIR"

# Copy the linux release binary (or executable bundle)
if [ -f build/linux/x64/release/bundle/${PKG_NAME} ]; then
  cp build/linux/x64/release/bundle/${PKG_NAME} "$ARCH_DIR/"
else
  # Try locate executable in build folder
  cp -r build/linux/ ${BUILD_DIR}/linux || true
fi

# Copy application icon from repo assets if available
if [ -f assets/icon/1.png ]; then
  cp assets/icon/1.png "$ICON_DIR/${PKG_NAME}.png"
fi

# Create .desktop file
cat > "$DESKTOP_DIR/${PKG_NAME}.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Mashhad Metro
Exec=/usr/bin/${PKG_NAME}
Icon=${PKG_NAME}
Categories=Utility;Education;
Terminal=false
EOF

# Create control file
mkdir -p "$BUILD_DIR/DEBIAN"
cat > "$BUILD_DIR/DEBIAN/control" <<EOF
Package: $PKG_NAME
Version: $VERSION
Section: utils
Priority: optional
Architecture: amd64
Maintainer: shahriaarrr
Description: Mashhad Metro Flutter App (Linux)
EOF

chmod -R 0755 "$BUILD_DIR"

DEB_FILE="build/${PKG_NAME}_${VERSION}_amd64.deb"
mkdir -p build
fakeroot dpkg-deb --build "$BUILD_DIR" "$DEB_FILE"

echo "Created $DEB_FILE"
