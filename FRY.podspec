# -*- coding: utf-8 -*-
Pod::Spec.new do |s|
  s.name         = "FRY"
  s.version      = "0.1"
  s.summary      = "An iOS integration library."

  s.description  = <<-DESC
                   FRY is an iOS Testing Library inspired by KIF. The purpose is to simplify the creation and execution of reliable automated UI tests.
                   DESC

  s.homepage     = "http://github.com/Raizlabs/FRY"
  s.license      = "MIT"
  s.author       = { "Brian King" => "brian.king@raizlabs.com" }
  s.platform     = :ios
  # s.platform   = :ios, "5.0"
  s.source       = { :git => "https://github.com/Raizlabs/FRY.git", :tag => "0.1" }

  s.source_files  = "FRY", "FRY/**/*.{h,m}"
  s.resources     = "**/*.png"

  s.public_header_files = "FRY/**/*.h"

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

end
