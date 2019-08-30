# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

source 'https://github.com/CocoaPods/Specs.git'
pod 'AFNetworking', '~> 3.1.0',:modular_headers => true        #Http 网络请求
pod 'Masonry', '~> 1.1.0'              #封装的Autolayout布局
pod 'JSONKit-iOS6Later'
pod 'YYModel'
pod 'SDWebImage'
pod 'MBProgressHUD'
pod 'RongCloudIM/IMLib'
pod 'MJRefresh'
pod 'GCCycleScrollView'
pod 'LKDBHelper'
pod 'FMDB'
pod 'ZipArchive'
#pod 'UMCCommon'
#pod 'UMCAnalytics'
#pod 'UMCSecurityPlugins'
#pod 'UMCPush'
pod 'SnapKit', '~>4.0.0'
pod 'MJExtension', '~> 3.0.15.1'
pod 'Bugly'
#pod 'QQ_XGPush', '~> 3.2.2'
pod 'BaiduMobStatCodeless'

pod 'AWSCore', git: 'https://github.com/ZHCliang/aws-sdk-ios.git'
pod 'AWSS3', git: 'https://github.com/ZHCliang/aws-sdk-ios.git'

#mob
# 主模块(必须)
pod 'mob_sharesdk'
# UI模块(非必须，需要用到ShareSDK提供的分享菜单栏和分享编辑页面需要以下1行)
pod 'mob_sharesdk/ShareSDKUI'
pod 'mob_sharesdk/ShareSDKPlatforms/SinaWeibo'
pod 'mob_sharesdk/ShareSDKPlatforms/WeChatFull'

#use_modular_headers!
source 'http://120.77.206.31/xiaobuke-app/iOS-Module-Spec.git'
pod 'OJNetworkComponet'
pod 'OJSearchComponent'
#pod 'OJConfigComponent'
#pod 'OJRCTalkComponent','1.3'
#pod 'OJDataSourceComponent',:modular_headers => true
#pod 'OJCategorylibs',:modular_headers => true
#pod 'OJSexChooseComponent',:modular_headers => true
pod 'OJCategorylibs',:modular_headers => true

#pod 'React', :path => 'node_modules/react-native', :subspecs => [
#'Core',
#'CxxBridge', # Include this for RN >= 0.47
#'DevSupport', # Include this to enable In-App Devmenu if RN >= 0.43
#'RCTText',
#'RCTNetwork',
#'RCTWebSocket', # needed for debugging
## Add any other subspecs you want to use in your project
#]
## Explicitly include Yoga if you are using RN >= 0.42.0
#pod 'yoga', :path => 'node_modules/react-native/ReactCommon/yoga'
#pod 'DoubleConversion', :podspec => 'node_modules/react-native/third-party-podspecs/DoubleConversion.podspec'
#pod 'glog', :podspec => 'node_modules/react-native/third-party-podspecs/glog.podspec'
#pod 'Folly', :podspec => 'node_modules/react-native/third-party-podspecs/Folly.podspec'
#
#pod 'CodePush', :path => 'node_modules/react-native-code-push'

target 'MiniBuKe' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!
  
  # Pods for MiniBuKe
  
  
  
  target 'MiniBuKeTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'MiniBuKeUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
end
