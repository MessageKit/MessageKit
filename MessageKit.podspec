Pod::Spec.new do |s|

  s.name = "MessageKit"
  s.version = "1.0"
  s.summary = "Super easy to use client for Hacker News API"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.homepage = "https://github.com/SD10/MessageKit"
  s.author = { "Steven Deutsch" => "stevensdeutsch@yahoo.com" }
  s.social_media_url = "https://twitter.com/_SD10_"
  s.platform = :ios, "9.0"
  s.requires_arc = "true"
  s.source = { git: "https://github.com/SD10/MessageKit.git", tag: "#{s.version}" }
  s.source_files = "MessageKit/**/*.*"
  s.pod_target_xcconfig = {
    "SWIFT_VERSION" => "3.0",
  }
end
