Pod::Spec.new do |spec|
  spec.name         = "TPFBasicSDK"
  spec.version      = "1.0.0"
  spec.summary      = "A short description of YourLibrary."
  spec.homepage     = "https://yourhomepage.com"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "panshiyu" => "panshiyu@iicall.com" }
  spec.source       = { :git => "https://github.com/panskycol/TPFBasicSDK.git", :tag => "#{spec.version}" }
  spec.platform     = :ios
  spec.source_files = "TPFBasicSDK/**/*.{h,m}"
  spec.requires_arc = true
end