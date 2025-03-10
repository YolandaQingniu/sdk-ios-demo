#
#  Be sure to run `pod spec lint QNSDK_XCFramework.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
s.name             = 'QNSDK_XCFramework'
s.version          = '0.0.1'
s.summary          = '轻牛旗下设备通讯类'

s.description      = '支持智能体脂秤、共享秤二维码数据解析'

s.homepage         = 'https://github.com/YolandaQingniu/sdk-ios-demo'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'service@qnniu.com' => 'service@qnniu.com' }
s.source           = { :git => 'https://github.com/YolandaQingniu/sdk-ios-demo.git', :tag => s.version.to_s}
s.ios.deployment_target = '8.0'

s.source_files = 'QNSDK/SDK/**/*.{h,m}'
s.vendored_frameworks = 'QNSDK/SDK/QNDeviceSDK.xcframework'
s.public_header_files= 'QNSDK/SDK/**/*.h'
s.static_framework = true
s.frameworks = 'CoreBluetooth'
s.xcconfig = {'BITCODE_GENERATION_MODE' => 'bitcode'}
s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
}
s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

end
