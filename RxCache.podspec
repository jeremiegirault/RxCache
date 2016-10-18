Pod::Spec.new do |s|
  s.name         = "RxCache"
  s.version      = "0.0.0"
  s.summary      = "Generalized cache mechanism for RxSwift."
  s.description  = <<-DESC
    TODO DESCRIPTION LOL
                   DESC
  s.homepage     = "https://github.com/RxSwiftCommunity/RxCache"
  s.license      = { :type => "MIT", :file => "License.md" }
  s.author             = { "Jérémie Girault" => "@kamidude" }
  s.social_media_url   = "http://twitter.com/kamidude"

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.source       = { :git => "https://github.com/RxSwiftCommunity/RxCache.git", :tag => s.version }
  s.source_files  = "*.{swift}"

  s.frameworks  = "Foundation"
  s.dependency "RxSwift"

#  s.watchos.exclude_files = 
#  s.osx.exclude_files = 
#  s.tvos.exclude_files = 
end
