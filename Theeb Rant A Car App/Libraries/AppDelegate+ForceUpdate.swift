//
//  AppDelegate+ForceUpdate.swift
//  Theeb Rent A Car App
//
//  Created by Sherif Kamal on 13/11/2022.
//

import Foundation
import Firebase

extension AppDelegate {
    
    func setCredentials(){
        let credentialKey = "app_credentials"
        if let forceRequiredDic = remoteConfig[credentialKey].jsonValue as? [String : AnyObject] {
            Self.credentialDict = forceRequiredDic
        }
    //    NetworkConfigration.urlString = Self.credentialDict?["base_url"] as? String
    }
    
    func setupRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        //set in app defaults
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        var expirationDuration = 60
        if remoteConfig.configSettings.minimumFetchInterval == 0 {
            expirationDuration = 0
        }
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) {[weak self] (status, error) -> Void in
            guard let self = self else { return }
            if status == .success {
                self.remoteConfig.activate { [weak self] changed, error in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        ForceUpdateChecker(listener: self).check()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.initWindow()
                }
            }
        }
    }
}

extension AppDelegate : OnUpdateNeededListener {
    func onUpdateNeeded(updateUrl: String, forceUpdate: Bool) {
        let forceUpdateDialog = UIAlertController(title: forceUpdate ? "force_update_title".localized : "force_update_title".localized, message: forceUpdate ? "force_update_message".localized : "normal_update_message".localized, preferredStyle: .alert)
        let updateAction = UIAlertAction(title: "update".localized, style: .default) { action in
            guard let url = URL(string: updateUrl) else { return }
            self.window?.rootViewController?.openURL(withURL: url)
        }
        forceUpdateDialog.addAction(updateAction)
        forceUpdateDialog.addAction(UIAlertAction(title: forceUpdate ? "exit_app".localized : "not_now".localized, style: .default, handler: { action in
            if forceUpdate {
                exit(0)
            } else {
                self.initWindow()
            }
        }))
        self.window?.rootViewController?.present(forceUpdateDialog, animated: true)
    }
    
    
    
    func onNoUpdateNeeded() {
        self.initWindow()
    }
}
