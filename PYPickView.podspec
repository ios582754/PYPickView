Pod::Spec.new do |s|
s.name = 'PYPickView'
s.version = '0.01'
s.license = 'MIT'
s.summary = 'An Animate Water view on iOS.'
s.homepage = 'hhttps://github.com/ios582754/PYPickView'
s.authors = { '董尚先' => 'dantesx2012@gmail.com' }
s.source = { :git => 'https://github.com/ios582754/PYPickView.git', :tag => s.version.to_s }
s.requires_arc = true
s.ios.deployment_target = '8.0'
s.source_files = 'PYPickView/*.{h,m}'
s.resources = 'PYPickView/*.plist'
end