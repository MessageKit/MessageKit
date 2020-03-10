# MessageKit, 2020		

# This runs on CI
mergeable_state = github.pr_json["mergeable_state"]

# Make it more obvious that a PR a draft
if mergeable_state == "draft"
    warn("PR is marked as Draft")
end

# Mainly to encourage writing up some reasoning about the PR, rather than just leaving a title
if github.pr_body.length < 5
    fail("Please provide a summary in the Pull Request description")
end

declared_hashtag = github.pr_title.include?("#trivial")
hasChangelogEntry = git.modified_files.include?("CHANGELOG.md")
if !hasChangelogEntry && !declared_hashtag
    fail("Please include a CHANGELOG entry. \nYou can find it at [CHANGELOG.md](https://github.com/MessageKit/MessageKit/blob/master/CHANGELOG.md).")
end

# Warn when there is a big PR
if git.lines_of_code > 1000
    warn("Big Pull Request - Please consider splitting up your changes into smaller Pull Requests.")
end

swiftlint.config_file = '.swiftlint.yml'
swiftlint.lint_files inline_mode:true, fail_on_error:true
