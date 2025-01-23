//
//  ForceUpdateChecker.swift
//  Theeb Rent A Car App
//
//  Created by Sherif Kamal on 13/11/2022.
//

import Foundation
import Firebase

protocol OnUpdateNeededListener {
    func onUpdateNeeded(updateUrl : String, forceUpdate: Bool)
    func onNoUpdateNeeded()
}

class ForceUpdateChecker {

    static let TAG = "ForceUpdateChecker"

    static let FORCE_UPDATE_STORE_URL = "force_update_store_url"
    static let FORCE_UPDATE_CURRENT_VERSION = "force_update_current_version"
    static let FORCE_UPDATE_REQUIRED = "force_update_required"
    
    var listener : OnUpdateNeededListener

    init(listener : OnUpdateNeededListener) {
        self.listener = listener
    }

    func check() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let forceRequired = remoteConfig[ForceUpdateChecker.FORCE_UPDATE_REQUIRED].boolValue

        print("\(ForceUpdateChecker.TAG) : forceRequired : \(forceRequired)")
        
        let currentVersion = remoteConfig[ForceUpdateChecker.FORCE_UPDATE_CURRENT_VERSION].stringValue
        print("\(ForceUpdateChecker.TAG) : currentVersion: \(currentVersion!)")

        if currentVersion != nil {
            let appVersion = getAppVersion()
            let appVersionStr = appVersion.replacingOccurrences(of: ".", with: "")
            let currentVersionStr = currentVersion?.replacingOccurrences(of: ".", with: "")
            
            if let currentVersionStr = currentVersionStr, let currentVersionNum = Int(currentVersionStr), let appVersion = Int(appVersionStr) {
                if currentVersionNum > appVersion {
                    let url = remoteConfig[ForceUpdateChecker.FORCE_UPDATE_STORE_URL].stringValue
                    if let url = url {
                        listener.onUpdateNeeded(updateUrl: url, forceUpdate: forceRequired)
                    }
                } else {
                    listener.onNoUpdateNeeded()
                }
            }
        } else {
            listener.onNoUpdateNeeded()
        }
    }

    func getAppVersion() -> String {
        let versionNumber = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String).trimmingCharacters(in: .whitespacesAndNewlines)
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

        let version = "\(versionNumber)"

        print("\(ForceUpdateChecker.TAG) : version: \(version)")

        return version
        
    }
}
