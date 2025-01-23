//
//  RegisterVC+Yaqeen.swift
//  Theeb Rent A Car App
//
//  Created by ahmed elshobary on 15/04/2024.
//

import Foundation

// yaqeen service

extension RegisterVC {
    
    func removeSpaces(from mobileNumber: String) -> String {
        return mobileNumber.replacingOccurrences(of: " ", with: "")
    }

    
    func setYaqeenDataToFields(){
        fullNameTextField.text = (userFullName.isEmpty) ? fullNameTextField.text : userFullName
        emailTextField.text = (userEmail.isEmpty) ? emailTextField.text : userEmail
        mobileTextField.text = (userPhone.isEmpty) ? mobileTextField.text : userPhone
    }
    func checkIsYaqeenCalled(response: YaqeenResponseModel){
        
        if response.driverImportRS?.isYakeenCalled ?? false {
            checkYakeenResponseStatus(response: response)
        } else {
            if (response.driverImportRS?.yakeenResponseStatus ?? true) == false && (response.driverImportRS?.yakeenResponseDescription?.contains("Yakeen already Verified") ?? false) {
                let fullName = [response.driverImportRS?.firstName, response.driverImportRS?.lastName].compactMap { $0 }.joined(separator: " ")

                userFullName = fullName
                userEmail = response.driverImportRS?.email ?? ""
                userPhone = response.driverImportRS?.mobile ?? ""
               // setYaqeenDataToFields()
                viewModel.navigatetoOtp(email: emailTextField.text ?? "", fullName: userFullName, idNumber: idorIqamaTextField.text ?? "", phoneNumber: (mobileTextField.text ?? "").withoutSpaces, iSDCode1: String(mobileTextField.selectedCountry?.phoneCode.dropFirst() ?? "").withoutSpaces, password: passwordTextField.text ?? "")
                
                //viewModel.navigatetoOtp(email: response.driverImportRS?.email, fullName:  fullName, idNumber: idorIqamaTextField.text ?? "", phoneNumber: response.driverImportRS?.mobile, iSDCode1: String(mobileTextField.selectedCountry?.phoneCode.dropFirst() ?? ""), password: passwordTextField.text ?? "")
            }
        }
    }
    
    func checkYakeenResponseStatus(response: YaqeenResponseModel) {
        if response.driverImportRS?.yakeenResponseStatus ?? false {
            let fullName = [response.driverImportRS?.firstName, response.driverImportRS?.lastName].compactMap { $0 }.joined(separator: " ")
            
            userFullName = fullName
            userEmail = response.driverImportRS?.email ?? ""
            userPhone = response.driverImportRS?.mobile ?? ""
           // setYaqeenDataToFields()
            viewModel.navigatetoOtp(email: emailTextField.text ?? "", fullName: userFullName, idNumber: idorIqamaTextField.text ?? "", phoneNumber: (mobileTextField.text ?? "").withoutSpaces, iSDCode1: String(mobileTextField.selectedCountry?.phoneCode.dropFirst() ?? "").withoutSpaces, password: passwordTextField.text ?? "")
            
            
          //  viewModel.navigatetoOtp(email: response.driverImportRS?.email, fullName:  fullName, idNumber: idorIqamaTextField.text ?? "", phoneNumber: response.driverImportRS?.mobile, iSDCode1: String(mobileTextField.selectedCountry?.phoneCode.dropFirst() ?? ""), password: passwordTextField.text ?? "")
        } else {
            self.alertUser(msg: response.driverImportRS?.varianceReason ?? "")
        }
    }
}
