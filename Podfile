# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'BuffaloChicken' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end

  # Pods for BuffaloChicken
  pod 'lottie-ios'
  pod 'ViewAnimator', '2.7.1'
  pod 'Firebase/Database'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'CodableFirebase'
  pod 'FirebaseUI'
end
