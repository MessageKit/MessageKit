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

test:
	@echo "Running MessageKit tests."
	@set -o pipefail && xcodebuild test -scheme MessageKit -sdk iphonesimulator -destination "platform=iOS Simulator,name=iPhone 16" | xcpretty -c

framework:
	@echo "Building MessageKit Framework."
	@set -o pipefail && xcodebuild build -scheme MessageKit -destination "platform=iOS Simulator,name=iPhone 16" | xcpretty -c

build_example:
	@echo "Building & analyzing MessageKit Example app."
	@cd Example && set -o pipefail && xcodebuild build analyze -scheme ChatExample -destination "platform=iOS Simulator,name=iPhone 16" CODE_SIGNING_REQUIRED=NO | xcpretty -c

test_example:
	@echo "Running MessageKit Example app UI tests."
	@cd Example && set -o pipefail && xcodebuild test -scheme ChatExampleUITests -destination "platform=iOS Simulator,name=iPhone 16" CODE_SIGNING_REQUIRED=NO | xcpretty -c

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
