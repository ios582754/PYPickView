
Pod::Spec.new do |s|
    s.name             = 'PYPickView'
    s.version          = '0.0.1'
    s.summary          = 'The easiest way to display in app PickView banners in iOS.'

    s.description      = <<-DESC
PickView is an extremely customizable and lightweight library that makes the task of displaying in app notification banners and drop down alerts an absolute breeze in iOS.
                       DESC

    s.homepage         = 'https://github.com/ios582754/PYPickView'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'pxy' => '1457582754@qq.com' }
    s.source           = { :git => 'https://github.com/ios582754/PYPickView.git', :tag => s.version.to_s }

    s.ios.deployment_target = '9.0'

    #s.source_files = 'PYPickView/**/*{h,m}'

    s.source_files  = "PYPickView", "PYPickView/**/*.{h,m}"

end