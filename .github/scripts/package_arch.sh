#!/usr/bin/env bash
set -euo pipefail

# Usage: package_arch.sh <tag>
TAG=${1:-dev}
# strip leading 'v'
VERSION="${TAG#v}"
PKG_NAME="mashhad_metro"
OUT_DIR="build"
PKGDIR="pkgbuild"

echo "Packaging Arch package for $PKG_NAME version $VERSION"

rm -rf "$PKGDIR"
mkdir -p "$PKGDIR/"{pkg,src}

# Copy binary
if [ -f build/linux/x64/release/bundle/${PKG_NAME} ]; then
  mkdir -p "$PKGDIR/pkg/usr/bin"
  cp build/linux/x64/release/bundle/${PKG_NAME} "$PKGDIR/pkg/usr/bin/"
else
  cp -r build/linux/ "$PKGDIR/pkg/opt/${PKG_NAME}" || true
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
pkgdesc="Mashhad Metro Flutter App"
arch=(x86_64)
license=('custom')
url="https://github.com/${GITHUB_REPOSITORY}"
# Maintainer / packager
# packager: shahriaarrr
depends=()
source=()
build() {
  return 0
}
package() {
  mkdir -p "$pkgdir/usr/bin"
  cp -r pkg/usr/bin/* "$pkgdir/usr/bin/"
}
EOF

pushd "$PKGDIR"

# Use fakeroot and tar to create package; if 'makepkg' is available use it, otherwise create a tarball as fallback
if command -v makepkg >/dev/null 2>&1; then
  makepkg --packagetype zst --noconfirm --syncdeps --skippgpcheck || true
  mv *.pkg.tar.* "../${OUT_DIR}/"
else
  # Fallback: create a tar.zst of the pkg contents
  TARFILE="../${OUT_DIR}/${PKG_NAME}-${VERSION}.pkg.tar.zst"
  mkdir -p ../${OUT_DIR}
  tar -C pkg -cf - . | zstd -19 -T0 -o "$TARFILE"
  echo "Created fallback Arch package: $TARFILE"
fi

popd
