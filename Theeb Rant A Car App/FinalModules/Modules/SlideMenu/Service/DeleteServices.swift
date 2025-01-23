//
//  DeleteServices.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 10/28/22.
//

import Foundation

class DeleteServices{
    func deleteUSerAccount(driverCode:String?,
                           success: APISuccess,
                           failure: APIFailure){
        guard let driverCode = driverCode else {return}
        NetworkManager.manager.request(isCustomLoader:false,soapAction: SOAPACTIONS.deleteSoap, xmlString: self.deleteDriverModelString(driverID: driverCode), url: BaseURL.production,success: success, failure: failure)
    }
    
    func deleteDriverModelString(driverID:String)->String{
        return "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:driv=\"DriverStatusRQ\"><soapenv:Header/><soapenv:Body><driv:DriverStatusRQ><driv:DriverCode>\(driverID)</driv:DriverCode><driv:DriverStatus>I</driv:DriverStatus></driv:DriverStatusRQ></soapenv:Body></soapenv:Envelope>"
        
    }
}
