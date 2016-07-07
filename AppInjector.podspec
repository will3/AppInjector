Pod::Spec.new do |s|
  s.name         = "AppInjector"
  s.version      = "0.0.1"
  s.summary      = "Light weight injector"
  s.homepage     = "https://github.com/will3/AppInjector"
  
  s.license      = 'MIT'
  s.author       = { "Will Zhou" => "will3.git@gmail.com" }
  s.social_media_url = "http://twitter.com/will3_z"
  s.source       = { :git => "https://github.com/will3/AppInjector.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'AppInjector/**/*.{swift}'
  s.frameworks = 'Foundation'
end