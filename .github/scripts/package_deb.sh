#!/usr/bin/env bash
set -euo pipefail

# Usage: package_deb.sh [tag]
# If tag is not provided or is a branch name, read version from pubspec.yaml

TAG=${1:-}
PKG_NAME="mashhad_metro"

# Function to read version from pubspec.yaml
get_version_from_pubspec() {
  if [ -f pubspec.yaml ]; then
    # Extract version line and get the version number
    VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: *//' | sed 's/+.*//')
    echo "$VERSION"
  else
    echo "1.0.0"
  fi
}

# Determine version
if [ -z "$TAG" ]; then
  # No tag provided, read from pubspec
  VERSION=$(get_version_from_pubspec)
  echo "No tag provided. Using version from pubspec.yaml: $VERSION"
elif [[ "$TAG" =~ ^v?[0-9]+\.[0-9]+\.[0-9]+ ]]; then
  # Valid version tag
  VERSION="${TAG#v}"
  echo "Using version from tag: $VERSION"
else
  # Invalid tag (like 'main'), read from pubspec
  VERSION=$(get_version_from_pubspec)
  echo "Tag '$TAG' is not a valid version. Using version from pubspec.yaml: $VERSION"
fi

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
  echo "Error: Binary not found at build/linux/x64/release/bundle/${PKG_NAME}"
  exit 1
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
 Complete guide for Mashhad Metro navigation
EOF

chmod -R 0755 "$BUILD_DIR"

DEB_FILE="build/${PKG_NAME}_${VERSION}_amd64.deb"
mkdir -p build
fakeroot dpkg-deb --build "$BUILD_DIR" "$DEB_FILE"

echo "Created $DEB_FILE"
