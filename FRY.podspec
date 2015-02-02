# -*- coding: utf-8 -*-
Pod::Spec.new do |s|
  s.name         = "FRY"
  s.version      = "0.4"
  s.summary      = "An iOS integration library."

  s.description  = <<-DESC
                   FRY is an iOS Testing Library inspired by KIF. The purpose is to simplify the creation and execution of reliable automated UI tests.
                   DESC

  s.homepage     = "http://github.com/Raizlabs/FRY"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Brian King" => "brianaking@gmail.com" }
  s.platform     = :ios, 7.0
  s.source       = { :git => "https://github.com/Raizlabs/FRY.git", :tag => "0.4" }

  s.source_files  = "FRY", "FRY/**/*.{h,m}"
  s.public_header_files = "FRY/**/*.h"
  s.requires_arc = true

end
