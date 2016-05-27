Pod::Spec.new do |s|
  s.name         = "MDFTextAccessibility"
  s.version      = "1.0.0"
  s.authors      = { 'Adrian Secord' => 'ajsecord@google.com' }
  s.summary      = "Accessibility tools for displaying text."
  s.homepage     = "https://github.com/google/material-text-accessibility-ios.git"
  s.license      = "Apache 2.0"
  s.source       = { :git => "https://github.com/google/material-text-accessibility-ios.git", :tag => s.version.to_s }
  s.platform     = :ios, "7.0"

  s.requires_arc = true
  s.public_header_files = "src/*.h"
  s.source_files = "src/*.{h,m}", "src/private/*.{h,m}"
  s.header_mappings_dir = "src/*"
end

