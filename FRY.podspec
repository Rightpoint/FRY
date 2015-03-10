# -*- coding: utf-8 -*-
Pod::Spec.new do |s|
  s.name         = "FRY"
  s.version      = "0.3"
  s.summary      = "An iOS integration library."

  s.description  = <<-DESC
                   FRY is an iOS Testing Library inspired by KIF. The purpose is to simplify the creation and execution of reliable automated UI tests.
                   DESC

  s.homepage     = "http://github.com/Raizlabs/FRY"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Brian King" => "brianaking@gmail.com" }
  s.platform     = :ios, 7.0
  s.source       = { :git => "https://github.com/Raizlabs/FRY.git", :tag => "0.3" }
  s.requires_arc = true

  s.default_subspec = 'Core'

  s.subspec "Core" do |core|
    core.source_files = "FRY/**/*.{h,m}"
    core.public_header_files = "FRY/**/*.h"
  end

  s.subspec "FRYolator" do |fryolator|
    fryolator.dependency "FRY/Core"
    fryolator.source_files = "FRYolator/**/*.{h,m}"
    fryolator.public_header_files = "FRYolator/**/*.h"
  end


end
