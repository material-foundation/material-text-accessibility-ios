Pod::Spec.new do |spec|
  spec.name         = "MDFTextAccessibility"
  spec.version      = "1.1.4"
  spec.summary      = "MDFTextAccessibility assists in selecting text colors that meet the W3C standards for accessibility."
  spec.homepage     = "https://github.com/google/material-text-accessibility-ios"
  spec.license      = "Apache License, Version 2.0"
  spec.authors      = "Google Inc."
  spec.source       = { :git => "https://github.com/google/material-text-accessibility-ios.git", :tag => "v#{spec.version}" }
  spec.platform     = :ios
  spec.source_files = "src/*.{h,m}", "src/private/*.{h,m}"
  spec.public_header_files = "src/MDFTextAccessibility.h"
  spec.private_header_files = "src/private/*.h"
  spec.header_dir   = "MDFTextAccessibility"
end
