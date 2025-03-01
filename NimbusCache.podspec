#
#  Be sure to run `pod spec lint NimbusCache.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "NimbusCache"
  spec.version      = "1.2.3"
  spec.summary      = "NimbusCache: Soar to new speeds with NimbusCache — a powerful caching framework inspired by the legendary Nimbus 2000!"
  spec.swift_version = "6.0"
  spec.description  = "NimbusCache: Soar to new speeds with NimbusCache — a powerful caching framework inspired by the legendary Nimbus 2000! Much like the broomstick that delivers unmatched speed and agility, NimbusCache provides efficient, seamless video and file caching for your iOS app. Currently optimized for AVPlayerItem video caching, it also offers the flexibility to manually cache other file types using downloadAndCache. Keep an eye out for expanded file type support as NimbusCache continues to grow and evolve! 🚀"

  spec.homepage     = "https://github.com/vijay-subramani/NimbusCache.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author = { "Vijay Subramani" => "vijaysubramani.ios.dev@gmail.com" }
  spec.source = { :git => "https://github.com/vijay-subramani/NimbusCache.git", :tag => "v#{spec.version}"}

  spec.source_files  = "Sources", "Sources/**/*.{swift}"
  spec.exclude_files = "Examples"

end
