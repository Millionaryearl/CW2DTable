#
# Be sure to run `pod lib lint CW2DTable.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CW2DTable"
  s.version          = "1.0.0"
  s.summary          = "CW2DTable is a self-defined UICollectionViewController to simulate commerial statistic tables."
  s.description      = <<-DESC
                       "CW2DTable is a self-defined UICollectionViewController to simulate commerial statistic tables. user could customize the data source in CW2DTableVC.m file - refreshSrchRlt method. A detailed demonstration for the data structure could be found there."
                        
                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/Millionaryearl/CW2DTable"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Millionaryearl" => "dukeweichen@gmail.com" }
  s.source           = { :git => "https://github.com/Millionaryearl/CW2DTable.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resources = 'Pod/Assets/*.png'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
