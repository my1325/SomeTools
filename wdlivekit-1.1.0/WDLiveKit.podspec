

Pod::Spec.new do |s|
  s.name             = 'WDLiveKit'
  s.version          = '1.1.0'
  s.summary          = 'WDLiveKit.'


  s.description      = "WDLiveKit WDLiveKit WDLiveKit"

  s.homepage         = 'http://gitlab.wudi360.com/liqinglian/wdlivekit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mimio' => 'xushizun01@wudi360.com' }
  s.source           = { :git => "http://gitlab.wudi360.com/liqinglian/wdlivekit.git", :tag => "#{s.version}" }
#  s.requires_arc     = true
#  s.ios.deployment_target = "11.0"
  s.swift_versions = ['5.3', '5.4', '5.5']
#  s.source_files     = ['WDLiveKit/**/*.{h,m,swift,pch,xib}']
#  s.subspec 'Code' do |ss|
#    ss.source_files = 'WDLiveKit/Classes/**/*'
#  end
  # s.resources = ['Resource/**/*.xcassets','Resource/**/*.lproj','Resource/**/*.svga','Resource/**/*.gif','Resource/**/*.otf']
#  s.resource_bundle = {
#    'WDLiveKit'=> ['WDLiveKit/**/*.{xcassets,xib,svga,gif,otf,lproj}']
#  }
#  s.prefix_header_contents = '#import "WDLiveKit.h"',''

s.ios.deployment_target = '11.0'

s.subspec 'Code' do |ss|
  ss.source_files = 'WDLiveKit/Classes/**/*'
end

s.resource_bundle = {
  'WDLiveKit'=> ['WDLiveKit/**/*.{xcassets,xib,svga,gif,otf,lproj}']
}

s.prefix_header_contents = '#import "WDLiveKit.h"'

  # 依赖
  # 声网直播 & 弹幕
  s.dependency 'AgoraRtcEngine_iOS'
  s.dependency 'AgoraRtm_iOS'
  # 模型解析
  s.dependency 'MJExtension'
  # svga
  s.dependency 'SVGAPlayer'
  # 图片
  s.dependency 'SDWebImage'
  # 自动布局
  s.dependency 'Masonry'
  s.dependency 'YYCategories'
  s.dependency 'YYImage'
  # 键盘自动控制
  s.dependency 'IQKeyboardManager'
#  s.dependency 'JXTAlertController'
#  s.dependency 'YBImageBrowser/Video'
  #
  s.dependency 'QQCorner'
  s.dependency "SnapKit"
  
end
