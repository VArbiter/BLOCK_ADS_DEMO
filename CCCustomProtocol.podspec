

Pod::Spec.new do |s|

  s.name         = "CCCustomProtocol"
  s.version      = "1.0.0"
  s.summary      = "A sample to use NSURLProtocol blocking ads ."

  s.description  = <<-DESC
    "A sample that use the NSURLProtocol to block ADS . The filter rules was came from ADBlocks . (URL && ads list is For test)"
                   DESC

  s.homepage     = "https://github.com/VArbiter/BLOCK_ADS_DEMO"

  s.license      = "MIT"

  s.author             = { "冯明庆" => "elwinfrederick@163.com" }

  s.platform     = :ios
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/VArbiter/BLOCK_ADS_DEMO.git", :tag => "#{s.version}" }

s.source_files  = "BLOCK_ADS_DEMO", "BLOCK_ADS_SUCCEED/BLOCK_ADS_SUCCEED/CCCustomProtocol/*.{h,m,plist}"

  s.requires_arc = true

end
