
Pod::Spec.new do |s|
	s.name         = "Channel"
	s.version      = "0.11.2"
	s.summary      = "The Channel iOS SDK makes it easier for you to integreate messaging into your app."


	s.description  = "Drop-in messaging sdk for your app. Send/Receive messages. In-app notification and Push notification."

	s.homepage     = "https://www.getchannel.co"
	s.screenshots  = "https://www.getchannel.co/img/ios.png"


	s.license      = "MIT"

	s.author             = { "Apisit Toompakdee" => "hello@mogohichi.com" }

	s.platform     = :ios, "10.0"


	s.source       = { :git => "https://github.com/mogohichi/channel-ios.git", :tag => "#{s.version}" }


	s.source_files  = "Source/Channel/**/*.{h,m}"
	s.exclude_files = "Source/Channel/Exclude"
	s.resources     = 'Source/Channel/**/*.{json,png,jpeg,jpg,storyboard,xib,xcassets,imageset}'

end
