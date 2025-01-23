import UIKit
import Firebase
import AppsFlyerLib
import Mixpanel

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var remoteConfig: RemoteConfig!
    static var credentialDict:[String:Any]?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Mixpanel.initialize(token: "93172fa661c2c1a7081d26ddcb9de686", trackAutomaticEvents: false)
        CachingManager.removeValue(forKey: CachingKeys.Locations)
        PushNotificationManager.manager.configure()
        Localizer.localize()
        PushNotificationManager.manager.registerForRemoteNotifications(application)
        GoogleMapsManager.initializeSDK()
        KeyboardHandler.shared.enableHandlingKeyboard()
      // initWindow()
        setupRemoteConfig()
        AppsFlyerLib.shared().appsFlyerDevKey = "Hs6fvGgx9SkLBbx5hZaoL"
        
        // production
        AppsFlyerLib.shared().appleAppID = "1417199904"
        
        // testing
      // AppsFlyerLib.shared().appleAppID = "100011122"
        AppsFlyerLib.shared().isDebug = false
        application.registerForRemoteNotifications()
        AppsFlyerLib.shared().useUninstallSandbox = false

        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
           AppsFlyerLib.shared().registerUninstall(deviceToken)
         }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerLib.shared().start()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        initWindow()
    }
    func initWindow()  {
        //UIApplication.shared.statusBarStyle = .lightContent
        setCredentials()
        if let _ = CachingManager.isFirstLogin {
            //he logged before
            setupRootViewController()
        }else{
            let appCode = Locale.autoupdatingCurrent.languageCode
           // Language.setCurrentLanguage(lang: appCode == "ar" ? .arabic : (appCode == "fr" ? .french:.english))
            switch appCode{
            case "ar":
                Language.setCurrentLanguage(lang: .arabic )
            case "en":
                Language.setCurrentLanguage(lang: .english)
            case "fr":
                Language.setCurrentLanguage(lang: .french)
            case "zh-Hans":
                Language.setCurrentLanguage(lang: .chinese)
            default:
                Language.setCurrentLanguage(lang: .english)
            }
            setupRootViewController()
            
        }
//        if Language.currentLanguage == .arabic {
//            UIView.appearance().semanticContentAttribute = .forceRightToLeft
//        } else {
//            UIView.appearance().semanticContentAttribute = .forceLeftToRight
//        }
    }
    
    func setupRootViewController() {
        let rootVC =  SplashVC.initializeFromStoryboard()
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
    }
    
  
}

