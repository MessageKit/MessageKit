Pod::Spec.new do |s|
   s.name = 'MessageKit'
   s.version = '1.0.0'
   s.license = 'MIT'

   s.summary = 'An elegant messages UI library for iOS.'
   s.homepage = 'http://messagekit.github.io'
   s.documentation_url = 'http://messagekit.github.io/docs'
   s.social_media_url = 'https://twitter.com/jesse_squires'
   s.author = 'Jesse Squires'

   s.source = { :git => 'https://github.com/MessageKit/MessageKit.git', :tag => s.version }
   s.source_files = 'Sources/*.swift'

   s.ios.deployment_target = '8.0'

   s.requires_arc = true
end
