#
# Be sure to run `pod lib lint QNDeviceSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'QNDeviceSDK'
s.version          = '0.4.9-beta.1'
s.summary          = '轻牛旗下设备通讯类'

s.description      = '支持智能体脂秤、共享秤二维码数据解析'

s.homepage         = 'https://github.com/YolandaQingniu/sdk-ios-demo'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'service@qnniu.com' => 'service@qnniu.com' }
s.source           = { :git => 'https://github.com/YolandaQingniu/sdk-ios-demo.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = 'QNDeviceSDK/**/*'
s.vendored_libraries = 'QNDeviceSDK/libQNDeviceSDK.a'
s.static_framework = true
s.frameworks = 'CoreBluetooth'

end
