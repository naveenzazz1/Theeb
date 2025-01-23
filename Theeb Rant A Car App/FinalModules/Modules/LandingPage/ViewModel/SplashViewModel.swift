//
//  SplashViewModel.swift
//  Theeb Rent A Car App
//
//  Created by ahmed elshobary on 24/07/2023.
//

import Foundation

class SplashViewModel: BaseViewModel {
    
    var showLoading: (() -> Void)?
    
}
extension SplashViewModel {
   
    func getToken() {
     //   self.showLoading?()
        
        // Create the object
        let params: [String: Any] = [
                "username": "TheebApp",
                "password": "L]AKv8Mn8W#-S3y2x8Hy",
                "client_id": "CarProAPI",
                "client_secret": "2D010372-0190-487E-BF44-E5A0F57837B7"
        ]
       
      let url =   self.convertToQueryParamters(params: AppDelegate.credentialDict ?? params, apiURL: NetworkConfigration.EndPoint.accessToken.rawValue)
        //NewNetworkManager.instance.paramaters = params
        NewNetworkManager.instance.requestRaw(url.absoluteString, type: .post,TokenModel.self)?.response(error: { [weak self] error in
            self?.error.send(error)
        }, receiveValue: { [weak self] model in
            guard let model = model else { return }
           // UD.LoginRemember = true
         //   UD.user = model.result
          //  self?.userData.send(model)
        }).store(self)
        
    }

}
