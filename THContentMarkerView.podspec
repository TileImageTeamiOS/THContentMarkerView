Pod::Spec.new do |s|

  s.name         = "THContentMarkerView"
  s.version      = "0.1.3"
  s.summary      = "THContentMarkerView is controller, 'THMarker' and 'THContentView'"
  s.description  = "'THContentMarkerView' is controller, use 'THMarker' and 'THContentSet'. 'THMarker' has marker position and marker content. 'THContentSet' is content view and content key."

  s.homepage     = "https://github.com/TileImageTeamiOS/THContentMarkerView"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors            = { "Hong Seong Ho" => "grohong76@gmail.com",  'Changnam Hong' => 'hcn1519@gmail.com', 'Han JeeWoong'=>'hjw01234@gmail.com'}

  s.ios.deployment_target = "9.0"
  s.source       = {  :git => "https://github.com/TileImageTeamiOS/THContentMarkerView.git", :tag => s.version.to_s }
  s.source_files  = 'THContentMarkerView/THContentMarker/*.swift'
  s.frameworks = 'UIKit'

end
