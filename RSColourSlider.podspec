#
# Be sure to run `pod lib lint RSColourSlider.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RSColourSlider'
  s.version          = '1.0.5'
  s.summary          = 'The Colour Slider for iOS and iPadOS projects.'


  s.description      = <<-DESC
TODO: This is a User Interface Slider that is able to help iOS users to choose their own colours. Easy to use, flexible settings.
                       DESC

  s.homepage         = 'https://github.com/uberdeviant/RSColourSlider'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ramil Uberdeviant Salimov' => 'salimov29@gmail.com' }
  s.source           = { :git => 'https://github.com/uberdeviant/RSColourSlider.git', :tag => "1.0.5" }
  s.social_media_url = 'https://twitter.com/mruberdeviant'

  s.ios.deployment_target = '12.0'

  s.source_files = 'Source/**/*'
  s.swift_version = '5.0'
  s.platform = :ios, "12.0"
  
end
