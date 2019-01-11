
Pod::Spec.new do |s|

s.name = "ZXSwitch"
s.versio = "0.0.1"
s.summary = "自己项目用来替代UISwitch控件"
s.homepage = "https://github.com/kwezdj123/ZXSwitch"
s.license = { :type => 'MIT', :file => 'LICENSE'}
s.author = { 'LoginPig' => 'woshiwangzhezhu@gmail.com' }
# s.source:项目的git代码仓库的地址，如格式为:{:git => "[git代码仓库地址]", tag => "[版本号]"}
s.source = { :git => 'https://github.com/kwezdj123/ZXSwitch.git'}
s.frameworks = "UIKit"
s.source_files = 'ZXSwitch/Classes/*.{swift}'
s.requires_arc = true

end