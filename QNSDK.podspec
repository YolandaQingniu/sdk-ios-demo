#
# Be sure to run `pod lib lint QNDeviceSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'QNSDK'
s.version          = '1.1.0'
s.summary          = '轻牛旗下设备通讯类'

s.description      = '支持智能体脂秤、共享秤二维码数据解析'

s.homepage         = 'https://github.com/YolandaQingniu/sdk-ios-demo'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'service@qnniu.com' => 'service@qnniu.com' }
s.source           = { :git => 'https://github.com/YolandaQingniu/sdk-ios-demo.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = 'QNSDK/SDK/**/*'
s.vendored_libraries = 'QNSDK/SDK/libQNDeviceSDK.a'
s.public_header_files= 'QNSDK/SDK/**/*.h'
s.static_framework = true
s.frameworks = 'CoreBluetooth'
s.xcconfig = {'BITCODE_GENERATION_MODE' => 'bitcode'}

end
