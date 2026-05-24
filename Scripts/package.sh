#!/bin/bash

# Generates Xcode project if missing
if [ ! -f "OpenCue.xcodeproj" ]; then
    xcodegen
fi

# Build for release
xcodebuild -project OpenCue.xcodeproj -scheme OpenCue -configuration Release clean build

# Create DMG from output
hdiutil create -volname "OpenCue" -srcfolder "$(PWD)/Build/Products/Release/OpenCue.app" -ov -format UDZO "OpenCue-1.0.0.dmg"

echo "Created OpenCue-1.0.0.dmg"
