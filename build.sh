#!/bin/bash

# MessageKit, 2020

set -e
function trap_handler {
  echo -e "\n\nOh no! You walked directly into the slavering fangs of a lurking grue!"
  echo "**** You have died ****"
  exit 255
}
trap trap_handler INT TERM EXIT

MODE="$1"

if [ "$MODE" = "tests" -o "$MODE" = "all" ]; then
  echo "Running MessageKit tests."
  carthage bootstrap --platform ios
  set -o pipefail && xcodebuild test -project MessageKit.xcodeproj -scheme MessageKitTests -destination "platform=iOS Simulator,name=iPhone 11 Pro" CODE_SIGNING_REQUIRED=NO | xcpretty -c
  success="1"
fi

if [ "$MODE" = "framework" -o "$MODE" = "all" ]; then
  echo "Building MessageKit Framework."
  carthage bootstrap --platform ios
  set -o pipefail && xcodebuild build -project MessageKit.xcodeproj -scheme MessageKit -destination "platform=iOS Simulator,name=iPhone 11 Pro" CODE_SIGNING_REQUIRED=NO | xcpretty -c
  success="1"
fi

if [ "$MODE" = "example" -o "$MODE" = "all" ]; then
  echo "Building & testing MessageKit Example app."
  cd Example
  gem install bundler
  bundle check || bundle install
  bundle exec pod install
  set -o pipefail && xcodebuild build analyze -workspace ChatExample.xcworkspace -scheme ChatExample -destination "platform=iOS Simulator,name=iPhone 11 Pro" ONLY_ACTIVE_ARCH=NO CODE_SIGNING_REQUIRED=NO | xcpretty -c
  success="1"
fi

if [ "$success" = "1" ]; then
trap - EXIT
exit 0
fi

echo "Unrecognised mode '$MODE'."
