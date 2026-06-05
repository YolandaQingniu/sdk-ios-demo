Pod::Spec.new do |s|
  s.name                  = 'QNDeviceSDK'
  s.version               = '1.0.0'
  s.summary               = '轻牛旗下设备通讯类'
  s.description           = '支持智能体脂秤、共享秤二维码数据解析'

  s.homepage              = 'https://github.com/YolandaQingniu/sdk-ios-demo'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { '13380054262@163.com' => '13380054262@163.com' }
  s.source                = { :git => 'https://github.com/YolandaQingniu/sdk-ios-demo.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.vendored_frameworks   = 'QNDeviceSDK/QNSDK.xcframework'
  s.static_framework      = true
  s.frameworks            = 'CoreBluetooth'
  s.requires_arc          = true
end
