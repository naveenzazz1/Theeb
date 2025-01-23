# Uncomment the next line to define a global platform for your project
 platform :ios, '14.0'

target 'Theeb Rent A Car App' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Theeb Rant A Car App

  pod 'IQKeyboardManagerSwift'
  pod 'SkyFloatingLabelTextField', '~> 3.0'
  pod "FlagPhoneNumber"
  pod 'XMLMapper', '~> 1.5.2'
  pod 'GoogleMaps'
  pod 'JVFloatLabeledTextField'
  pod 'GooglePlaces'
  pod 'SwiftyXMLParser'
  pod 'Fastis', '~> 1.0.0'
  pod 'ObjectMapper', '~> 3.3'
 # pod 'KeychainSwift' '~> 20.0'
  pod 'ViewAnimator'
  pod 'GLWalkthrough'
 pod 'Firebase'
  pod 'Firebase/Core'
  pod 'Firebase/RemoteConfig'
  pod 'FirebaseAnalytics'
  pod 'FirebaseMessaging'
  pod 'Firebase/Crashlytics'
  pod 'CalendarDateRangePickerViewController'
  target 'Theeb Rent A Car AppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Theeb Rent A Car AppUITests' do
    # Pods for testing
  end

end
post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
            end
        end
    end
end
