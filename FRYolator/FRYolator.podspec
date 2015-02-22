# _*- coding: utf-8 -*-
Pod::Spec.new do |s|
  s.name         = "FRYolator"
  s.version      = "0.3"
  s.summary      = "A helper for FRY, an iOS integration library."

  s.description  = <<-DESC
                   FRYolator is a helper library for writing iOS tests with FRY.
                   DESC

  s.homepage     = "http://github.com/Raizlabs/FRY"
  s.license      = { :type => "MIT", :file => "../LICENSE" }
  s.author       = { "Brian King" => "brianaking@gmail.com" }
  s.platform     = :ios, 7.0
  s.source       = { :git => "https://github.com/Raizlabs/FRY.git", :tag => "0.3" }

  s.dependency 'FRY', '~> 0.3'
  s.source_files  = "FRYolator/**/*.{h,m}"
  s.public_header_files = "FRYolator/**/*.h"
  s.requires_arc = true

end
