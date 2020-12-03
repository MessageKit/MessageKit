#!/bin/bash

#
# MIT License
#
# Copyright (c) 2017-2020 MessageKit
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
  set -o pipefail && xcodebuild test -scheme MessageKit -sdk iphonesimulator -destination "platform=iOS Simulator,name=iPhone 11" | xcpretty -c
  success="1"
fi

if [ "$MODE" = "framework" -o "$MODE" = "all" ]; then
  echo "Building MessageKit Framework."
  set -o pipefail && xcodebuild build -scheme MessageKit -destination "platform=iOS Simulator,name=iPhone 11" | xcpretty -c
  success="1"
fi

if [ "$MODE" = "example" -o "$MODE" = "all" ]; then
  echo "Building & testing MessageKit Example app."
  cd Example
  set -o pipefail && xcodebuild build analyze -scheme ChatExample -destination "platform=iOS Simulator,name=iPhone 11" CODE_SIGNING_REQUIRED=NO | xcpretty -c
  success="1"
fi

if [ "$success" = "1" ]; then
trap - EXIT
exit 0
fi

echo "Unrecognised mode '$MODE'."
