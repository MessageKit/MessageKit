// MIT License
//
// Copyright (c) 2017-2026 MessageKit
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Danger

// This runs on CI
let danger = Danger()
let pullRequest = danger.github.pullRequest

// Make it more obvious that a PR is a Draft
if pullRequest.draft == true {
  warn("PR is marked as Draft")
}

// Make it more obvious that a PR is a work in progress and shouldn't be merged yet
if pullRequest.title.contains("[WIP]") {
  warn("PR is marked as Work in Progress")
}

// Mainly to encourage writing up some reasoning about the PR, rather than just leaving a title
if (pullRequest.body ?? "").count < 5 {
  fail("Please provide a summary in the Pull Request description")
}

let declaredTrivial = pullRequest.title.contains("#trivial")
let hasChangelogEntry = danger.git.modifiedFiles.contains("CHANGELOG.md")
if !hasChangelogEntry, !declaredTrivial {
  fail(
    "Please include a CHANGELOG entry. \nYou can find it at [CHANGELOG.md](https://github.com/MessageKit/MessageKit/blob/main/CHANGELOG.md).")
}

// Warn when there is a big PR
let linesOfCode = (pullRequest.additions ?? 0) + (pullRequest.deletions ?? 0)
if linesOfCode > 1000 {
  warn("Big Pull Request - Please consider splitting up your changes into smaller Pull Requests.")
}

// SwiftLint ships inside Danger Swift, so it only needs the `swiftlint` binary on the PATH
SwiftLint.lint(.modifiedAndCreatedFiles(directory: nil), inline: true, configFile: ".swiftlint.yml")
