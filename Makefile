# MIT License
#
# Copyright (c) 2017-2022 MessageKit
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

.SHELLFLAGS = -ec
.SHELL = /bin/bash

# Building needs a platform, not a booted device, so ask for the platform only.
# Naming a device model here breaks whenever a machine ships a different one.
BUILD_DESTINATION = generic/platform=iOS Simulator

# Running tests does need a real simulator, so resolve whichever iPhone is
# installed rather than pinning a model. Override with `make test SIMULATOR_ID=<udid>`.
SIMULATOR_ID ?= $(shell xcrun simctl list devices available | grep -m1 "iPhone" | grep -oE "[0-9A-F-]{36}")

require_simulator:
	@test -n "$(SIMULATOR_ID)" || { \
		echo "No iPhone simulator is available."; \
		echo "Install one from Xcode > Settings > Components, or pass SIMULATOR_ID=<udid>."; \
		exit 1; \
	}

test: require_simulator
	@echo "Running MessageKit tests."
	@set -o pipefail && xcodebuild test -scheme MessageKit -destination "id=$(SIMULATOR_ID)" | xcpretty -c

framework:
	@echo "Building MessageKit Framework."
	@set -o pipefail && xcodebuild build -scheme MessageKit -destination "$(BUILD_DESTINATION)" | xcpretty -c

build_example:
	@echo "Building & analyzing MessageKit Example app."
	@cd Example && set -o pipefail && xcodebuild build analyze -scheme ChatExample -destination "$(BUILD_DESTINATION)" CODE_SIGNING_REQUIRED=NO | xcpretty -c

test_example: require_simulator
	@echo "Running MessageKit Example app UI tests."
	@cd Example && set -o pipefail && xcodebuild test -scheme ChatExampleUITests -destination "id=$(SIMULATOR_ID)" CODE_SIGNING_REQUIRED=NO | xcpretty -c

format:
	@echo "Formatting MessageKit."
	@swiftformat .

lint:
	@echo "Linting MessageKit."
	@swiftformat --lint .
	@swiftlint lint --quiet

setup:
	@mkdir -p .git/hooks
	@rm -f .git/hooks/pre-commit
	@cp ./Scripts/pre-commit ./.git/hooks
	@chmod +x .git/hooks/pre-commit
