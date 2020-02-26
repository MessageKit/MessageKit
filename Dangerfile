# By Jakub Kaspar 26/02/2020
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

if !git.modified_files.include?("CHANGELOG.md") && has_app_changes
  fail("Please include a CHANGELOG entry. \nYou can find it at [CHANGELOG.md](https://github.com/MessageKit/MessageKit/blob/master/CHANGELOG.md).")
end

# Warn when there is a big PR
if git.lines_of_code > 1000
  warn("Big PR - you should create smaller!")
end

swiftlint.config_file = '.swiftlint.yml'
swiftlint.lint_files inline_mode:true
swiftlint.lint_files fail_on_error:true
