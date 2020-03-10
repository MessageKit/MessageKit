//  MessageKit, 2020

import Danger

let danger = Danger()
let allSourceFiles = danger.git.modifiedFiles + danger.git.createdFiles

let changelogChanged = allSourceFiles.contains("CHANGELOG.md")
let declaredHashtag = danger.github.pullRequest.title.contains("#trivial")

if !changelogChanged && !declaredHashtag {
  fail("Please include a CHANGELOG entry. \nYou can find it at [CHANGELOG.md](https://github.com/MessageKit/MessageKit/blob/master/CHANGELOG.md).")
}

var bigPRThreshold = 1000
let additions = danger.github.pullRequest.additions ?? 0
let deletions = danger.github.pullRequest.deletions ?? 0
if additions + deletions > bigPRThreshold {
  warn("Pull Request size seems relatively large - Please consider splitting up your changes into smaller Pull Requests.")
}

SwiftLint.lint(inline: true)
