Pod::Spec.new do |s|
  s.name         = "Clue"
  s.version      = "0.1.0"
  s.summary      = "Clue is a smart-bug report framework for iOS, which allow you to record full bug/crash report and send it to you as a .clue file via email"
  s.description  = <<-DESC
  Clue.framework records all required information from user's device so you’ll be able to fix bug or crash really fast.
  Just import and setup Clue.framework in your iOS application (Xcode project) and after shake gesture you'd be able to start bug report recording.
  During that recording you can do whatever you want to reproduce the bug.
  After you’re done you need to shake the device (or simulator) once again (or tap on recording indicator view)
  and Clue will send the .clue file with Network, View Structure, User Interactions and Device Information with to your inbox.
                   DESC
  s.homepage     = "https://github.com/Geek-1001/Clue"
  # TODO: add screenshot links
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  # TODO: add docuemntation url
  # s.documentation_url = "http://www.example.com/docs.html"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Ahmed Sulaiman" => "demhasul@gmail.com" }
  s.social_media_url   = "http://twitter.com/ahmed_sulajman"
  s.platform     = :ios
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/Geek-1001/Clue.git", :tag => "#{s.version}" }
  s.source_files  = "Clue/Classes/**/*.{h,m}", "Clue/*.{h,m}"
  s.public_header_files = "Clue/*.h", "Clue/Classes/Models/CLUOptions.h"
  s.module_name = "Clue"
  s.frameworks  = "Foundation", "UIKit", "MessageUI", "AVFoundation"
  s.libraries   = "z"
  s.requires_arc = true
end
