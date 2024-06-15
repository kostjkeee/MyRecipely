#!/bin/bash

pkill -x Xcode
rm -rf Recipely.xcodeproj Recipely.xcworkspace
xcodegen
pod install
open Recipely.xcworkspace
