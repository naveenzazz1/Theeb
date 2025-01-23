//
//  UserProfileVC+Yaqeen.swift
//  Theeb Rent A Car App
//
//  Created by ahmed elshobary on 16/04/2024.
//

import Foundation
// yaqeen service

extension UserProfileVC {
    func checkIsYaqeenCalled(response: YaqeenResponseModel){
        
        if response.driverImportRS?.isYakeenCalled ?? false {
            checkYakeenResponseStatus(response: response)
        } else {
            if (response.driverImportRS?.yakeenResponseStatus ?? true) == false && (response.driverImportRS?.yakeenResponseDescription?.contains("Yakeen already Verified") ?? false) {
                saveBtnPressed()
            }
        }
    }
    
    func checkYakeenResponseStatus(response: YaqeenResponseModel) {
        if response.driverImportRS?.yakeenResponseStatus ?? false {
            saveBtnPressed()
        } else {
            self.alertUser(msg: response.driverImportRS?.varianceReason ?? "")
        }
    }
}
