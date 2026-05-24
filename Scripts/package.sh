#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Ensure we run from the project root
cd "$(dirname "$0")/.."

# Source .env if it exists
if [ -f ".env" ]; then
    echo "Sourcing .env file..."
    source .env
fi

DEV_ID_APP="${DEVELOPER_ID_APPLICATION}"
APPLE_ID="${APPLE_ID}"
APP_SPECIFIC_PASSWORD="${APP_SPECIFIC_PASSWORD}"
TEAM_ID="${TEAM_ID}"
VERSION="${APP_VERSION:-1.0.0}"
DMG_NAME="OpenCue-${VERSION}.dmg"
BUILD_DIR="$(PWD)/Build/Products"
APP_PATH="${BUILD_DIR}/Release/OpenCue.app"

if [ -z "$DEV_ID_APP" ]; then
    echo "❌ DEVELOPER_ID_APPLICATION is missing."
    echo "Please set it in your .env file to sign the app (e.g. Developer ID Application: Your Name (TEAMID))"
    exit 1
fi

echo "====================================="
echo "🛠️  Building OpenCue..."
echo "====================================="

# Generate Xcode project if missing
if [ ! -d "OpenCue.xcodeproj" ]; then
    echo "Generating Xcode project using xcodegen..."
    xcodegen
fi

# Build the project for release
xcodebuild -project OpenCue.xcodeproj \
           -scheme OpenCue \
           -configuration Release \
           SYMROOT="${BUILD_DIR}" \
           clean build

echo "====================================="
echo "🔐 Signing the App Bundle..."
echo "====================================="
# --options runtime is REQUIRED by Apple for notarization (enables Hardened Runtime)
codesign --deep --force --verify --verbose --sign "$DEV_ID_APP" --options runtime "$APP_PATH"

echo "====================================="
echo "📦 Creating DMG..."
echo "====================================="
rm -f "$DMG_NAME"
hdiutil create -volname "OpenCue" -srcfolder "$APP_PATH" -ov -format UDZO "$DMG_NAME"

echo "====================================="
echo "🔐 Signing the DMG..."
echo "====================================="
codesign --force --verify --verbose --sign "$DEV_ID_APP" "$DMG_NAME"

# Check if we should notarize
if [ -z "$APPLE_ID" ] || [ -z "$APP_SPECIFIC_PASSWORD" ] || [ -z "$TEAM_ID" ]; then
    echo "⚠️  Notarization skipped!"
    echo "To notarize, you must provide your Apple Developer credentials in the .env file:"
    echo "  APPLE_ID, APP_SPECIFIC_PASSWORD, and TEAM_ID are missing."
    echo "Finished generating signed/unnotarized $DMG_NAME"
    exit 0
fi

echo "====================================="
echo "☁️  Submitting to Apple Notary Service..."
echo "====================================="
# We use --wait to block until Apple finishes the notarization check
xcrun notarytool submit "$DMG_NAME" \
    --apple-id "$APPLE_ID" \
    --password "$APP_SPECIFIC_PASSWORD" \
    --team-id "$TEAM_ID" \
    --wait

echo "====================================="
echo "📎 Stapling Notarization Ticket..."
echo "====================================="
xcrun stapler staple "$DMG_NAME"

echo "====================================="
echo "✅ Success: $DMG_NAME is fully built, signed, and notarized!"
echo "====================================="
