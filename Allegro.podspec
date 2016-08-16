Pod::Spec.new do |s|
  s.name         = "Allegro"
  s.version      = "1.2.2"
  s.summary      = "Dynamic Type Construction In Swift"
  s.description  = <<-DESC
                    Allegro allows you to create struct and class instances at runtime.
                   DESC
  s.homepage     = "https://github.com/bradhilton/Allegro"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Brad Hilton" => "brad@skyvive.com" }
  s.source       = { :git => "https://github.com/bradhilton/Allegro.git", :tag => "1.2.2" }

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"

  s.source_files  = "Sources", "Sources/**/*.{swift,h,m}"
  s.requires_arc = true

end
