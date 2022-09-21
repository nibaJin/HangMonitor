#
# Be sure to run `pod lib lint HangMonitor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HangMonitor'
  s.version          = '0.1.0'
  s.summary          = 'iOS轻量级主线程卡顿、卡死监控工具'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  iOS轻量级主线程卡顿、卡死监控工具.
                       DESC

  s.homepage         = 'https://github.com/nibaJin/HangMonitor.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jin fu' => 'fujin@banggood.com' }
  s.source           = { :git => 'https://github.com/nibaJin/HangMonitor.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'HangMonitor/Classes/**/*'
  
  s.public_header_files = 'HangMonitor/Classes/BGHangMonitor.h'
end
