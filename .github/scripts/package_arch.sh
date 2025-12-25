#!/usr/bin/env bash
set -euo pipefail

# Usage: package_arch.sh [tag]
# If tag is not provided or is a branch name, read version from pubspec.yaml

TAG=${1:-}
PKG_NAME="mashhad_metro"
OUT_DIR="build"
PKGDIR="pkgbuild"

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

echo "Packaging Arch package for $PKG_NAME version $VERSION"

rm -rf "$PKGDIR"
mkdir -p "$PKGDIR/"{pkg,src}

# Copy binary
if [ -f build/linux/x64/release/bundle/${PKG_NAME} ]; then
  mkdir -p "$PKGDIR/pkg/usr/bin"
  cp build/linux/x64/release/bundle/${PKG_NAME} "$PKGDIR/pkg/usr/bin/"
else
  echo "Error: Binary not found at build/linux/x64/release/bundle/${PKG_NAME}"
  exit 1
fi

# Include icon and desktop file in package
mkdir -p "$PKGDIR/pkg/usr/share/icons/hicolor/128x128/apps"
mkdir -p "$PKGDIR/pkg/usr/share/applications"
if [ -f assets/icon/1.png ]; then
  cp assets/icon/1.png "$PKGDIR/pkg/usr/share/icons/hicolor/128x128/apps/${PKG_NAME}.png"
fi

cat > "$PKGDIR/pkg/usr/share/applications/${PKG_NAME}.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Mashhad Metro
Exec=/usr/bin/${PKG_NAME}
Icon=${PKG_NAME}
Categories=Utility;Education;
Terminal=false
EOF

cat > "$PKGDIR/PKGBUILD" <<EOF
pkgname=${PKG_NAME}
pkgver=${VERSION}
pkgrel=1
pkgdesc="Mashhad Metro Flutter App - Complete guide for Mashhad Metro navigation"
arch=(x86_64)
license=('custom')
url="https://github.com/\${GITHUB_REPOSITORY:-shahriaarrr/mashhad_metro}"
# Maintainer / packager
# packager: shahriaarrr
depends=()
source=()
build() {
  return 0
}
package() {
  mkdir -p "\$pkgdir/usr/bin"
  mkdir -p "\$pkgdir/usr/share/icons/hicolor/128x128/apps"
  mkdir -p "\$pkgdir/usr/share/applications"
  
  cp -r "\$srcdir/../pkg/usr/bin/"* "\$pkgdir/usr/bin/"
  cp -r "\$srcdir/../pkg/usr/share/icons/hicolor/128x128/apps/"* "\$pkgdir/usr/share/icons/hicolor/128x128/apps/" || true
  cp -r "\$srcdir/../pkg/usr/share/applications/"* "\$pkgdir/usr/share/applications/" || true
}
EOF

pushd "$PKGDIR"

# Use fakeroot and tar to create package
if command -v makepkg >/dev/null 2>&1; then
  makepkg --packagetype zst --noconfirm --skippgpcheck || {
    echo "makepkg failed, creating fallback tarball"
    TARFILE="../${OUT_DIR}/${PKG_NAME}-${VERSION}-1-x86_64.pkg.tar.zst"
    mkdir -p ../${OUT_DIR}
    tar -C pkg -cf - . | zstd -19 -T0 -o "$TARFILE"
    echo "Created fallback Arch package: $TARFILE"
  }
  mv *.pkg.tar.* "../${OUT_DIR}/" 2>/dev/null || true
else
  # Fallback: create a tar.zst of the pkg contents
  TARFILE="../${OUT_DIR}/${PKG_NAME}-${VERSION}-1-x86_64.pkg.tar.zst"
  mkdir -p ../${OUT_DIR}
  tar -C pkg -cf - . | zstd -19 -T0 -o "$TARFILE"
  echo "Created fallback Arch package: $TARFILE"
fi

popd

echo "Arch package created successfully!"