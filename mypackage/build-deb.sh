#!/bin/bash
set -e

# 🔸 Use environment variable, or fail if not set
if [ -z "$PKG_VERSION" ]; then
  echo "Error: PKG_VERSION environment variable is not set"
  exit 1
fi

PKG_NAME="mypackage"
ARCH="all"
MAINTAINER="Masatoshi Tanida <masatoshi@example.com>"
DESCRIPTION="A minimal Debian package that installs a script."

BUILD_DIR="build/${PKG_NAME}-${PKG_VERSION}"
SCRIPT_SRC="myscript.sh"
SCRIPT_DEST="usr/local/bin/myscript"

# 🔄 Clean previous build
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/DEBIAN"
mkdir -p "$BUILD_DIR/usr/local/bin"

# 📝 Control file
cat > "$BUILD_DIR/DEBIAN/control" <<EOF
Package: $PKG_NAME
Version: $PKG_VERSION
Section: base
Priority: optional
Architecture: $ARCH
Maintainer: $MAINTAINER
Description: $DESCRIPTION
EOF

# ➕ Copy script
cp "$SCRIPT_SRC" "$BUILD_DIR/$SCRIPT_DEST"
chmod +x "$BUILD_DIR/$SCRIPT_DEST"

# 📦 Build .deb
dpkg-deb --build "$BUILD_DIR"
mv "$BUILD_DIR.deb" "${PKG_NAME}_${PKG_VERSION}.deb"

echo "✅ Package built: ${PKG_NAME}_${PKG_VERSION}.deb"
