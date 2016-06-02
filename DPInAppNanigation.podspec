Pod::Spec.new do |s|

  s.name         = "DPInAppNanigation"
  s.version      = "1.0"
  s.summary      = "Allow navigate with URLs "
  s.homepage     = "https://github.com/nullic/DPInAppNanigation"
  s.license      = "MIT"
  s.author       = { "Dmitriy Petrusevich" => "nullic@gmail.com" }
  s.platform     = :ios, "5.0"

  s.source       = { :git => "https://github.com/nullic/DPAlertsDispatcher.git", :tag => "1.1" }
  s.source_files = "DPInAppNanigation", "DPInAppNanigation/*.{h,m}"
  s.requires_arc = true

end
