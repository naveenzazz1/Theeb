//
//  File.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 11/07/1443 AH.
//

import UIKit


class GetAvailabelCarsService  {
    
    func getAvailableCarsSerivce(vehicleTypeCode: String? = nil,
                                 success: APISuccess,
                                 failure: APIFailure) {
        
        
        NetworkManager.manager.request(isCustomLoader:false,soapAction: SOAPACTIONS.carModel, xmlString: self.carModelTypeXmlString(carType: vehicleTypeCode), url: BaseURL.production,success: success, failure: failure)
        
        
        
    }
    
    func getPriceEstimation(outBranch: Int?,
                                   inBranch:Int?,
                                   outDate: String?,
                                   inDate:String?,
                                   outTime: String?,
                                   inTime: String?,
                                   vehicleType : String?,
                                   driverCode : String? = nil,
                                   success: APISuccess,
                                   failure: APIFailure) {
        
        NetworkManager.manager.request(isCustomLoader:false,soapAction: SOAPACTIONS.priceEstimation, xmlString: self.priceEstimationRequest(outBranch: outBranch, inBranch: inBranch, outDate: outDate, inDate: inDate, outTime: outTime, inTime: inTime, vehicleType: vehicleType, driverCode: CachingManager.loginObject()?.driverCode), url: BaseURL.BaseUrlPriceEstimation,success: success, failure: failure)
        
        
    }
    
    func getPriceEstimationForMore(success: APISuccess,
                                   failure: APIFailure) {
        
        NetworkManager.manager.request(isCustomLoader:false,soapAction: SOAPACTIONS.priceEstimation, xmlString: self.priceEstimationForTariff(), url: BaseURL.BaseUrlPriceEstimation,success: success, failure: failure)
        
        
    }
    
    func getVechileTypes(success: APISuccess,
                         failure: APIFailure) {
        
        NetworkManager.manager.request(isCustomLoader:false,soapAction: SOAPACTIONS.vehicleType, xmlString: self.vehicleType(), url: BaseURL.production,success: success, failure: failure)
        
    }
    
     func changeDateFormat(changeDate : Date, format : String) ->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format //Set date style
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.init(identifier: Locale.current.identifier)
 
        let localDate = dateFormatter.string(from: changeDate)
        
        return localDate
    }
    
    
    func carModelTypeXmlString(carType:String?) -> String?
    {
        return "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><SOAP-ENV:Body><m:VehicleTypes xmlns:m=\"VehicleTypeWS\"><m:VehicleType>\(carType ?? "")</m:VehicleType></m:VehicleTypes></SOAP-ENV:Body></SOAP-ENV:Envelope>"
    }
    
    
    
    
    func priceEstimationRequest(outBranch: Int?,
                                inBranch:Int?,
                                outDate: String?,
                                inDate:String?,
                                outTime: String?,
                                inTime: String?,
                                vehicleType : String?,
                                driverCode : String?) -> String? {
        var extras = String()
        extras.append("<car:Extra><car:Code></car:Code><car:Name></car:Name><car:Quantity></car:Quantity></car:Extra>")
        
        return "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:car=\"CarproPriceEstimation\"><soapenv:Header/><soapenv:Body><car:EstimationDetails><car:Price><car:CDP></car:CDP><car:OutBranch>\(outBranch ?? 0)</car:OutBranch><car:InBranch>\(inBranch ?? 0)</car:InBranch><car:OutDate>\(outDate ?? "")</car:OutDate><car:OutTime>\(outTime ?? "")</car:OutTime><car:InDate>\(inDate!)</car:InDate><car:InTime>\(inTime ?? "")</car:InTime><car:CarGroup></car:CarGroup><car:Currency>SAR</car:Currency><car:DebitorCode></car:DebitorCode><car:VoucherType></car:VoucherType><car:VoucherNo></car:VoucherNo><car:VEHICLETYPE>\(vehicleType ?? "")</car:VEHICLETYPE><car:Booked>\(extras )</car:Booked><car:DriverCode>\(driverCode ?? "")</car:DriverCode></car:Price></car:EstimationDetails></soapenv:Body></soapenv:Envelope>"
        
    }
    
     func vehicleType() -> String?
    {
        return "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><SOAP-ENV:Body><m:VehicleTypes xmlns:m=\"VehicleTypeWS\"><m:VehicleType></m:VehicleType></m:VehicleTypes></SOAP-ENV:Body></SOAP-ENV:Envelope>"
    }
    
     func priceEstimationRequest() -> String? {
        return "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:car=\"CarproPriceEstimation\"><soapenv:Header/><soapenv:Body><car:EstimationDetails UserId=\"?\" UserPassword=\"?\"><car:Price><car:CDP>?</car:CDP><car:InBranch></car:InBranch><car:OutBranch></car:OutBranch><car:OutDate></car:OutDate><car:OutTime></car:OutTime><car:InDate></car:InDate><car:InTime></car:InTime><car:CarGroup>ALL</car:CarGroup><car:Currency>SAR</car:Currency><car:DebitorCode>?</car:DebitorCode><car:VoucherType>?</car:VoucherType><car:VoucherNo>?</car:VoucherNo><car:VEHICLETYPE>?</car:VEHICLETYPE><car:Booked><car:Insurance><car:Code>?</car:Code><car:Name>?</car:Name><car:Quantity>?</car:Quantity></car:Insurance><car:Extra><car:Code>?</car:Code><car:Name>?</car:Name><car:Quantity>?</car:Quantity></car:Extra></car:Booked></car:Price></car:EstimationDetails></soapenv:Body></soapenv:Envelope>"
}
    
     func priceEstimationForTariff() -> String?
    {
        let startDatePrice = changeDateFormat(changeDate: Date(), format: "dd/MM/yyyy")
        let endDatePrice = changeDateFormat(changeDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, format: "dd/MM/yyyy")
       return  "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"\nxmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" \nxmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \nxmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><SOAP-ENV:Body><m:EstimationDetails xmlns:m=\"CarproPriceEstimation\" UserId=\"\" UserPassword=\"\"><m:Price><m:CDP></m:CDP><m:OutBranch>97</m:OutBranch><m:InBranch>97</m:InBranch><m:OutDate>\(startDatePrice)</m:OutDate><m:OutTime>19:41</m:OutTime><m:InDate>\(endDatePrice)</m:InDate><m:InTime>19:41</m:InTime><m:CarGroup></m:CarGroup><m:Currency>SAR</m:Currency><m:DebitorCode></m:DebitorCode><m:VoucherType></m:VoucherType><m:Booked><m:Insurance><m:Code></m:Code><m:Name></m:Name><m:Quantity></m:Quantity></m:Insurance><m:Extra><m:Code></m:Code><m:Name></m:Name><m:Quantity></m:Quantity></m:Extra></m:Booked></m:Price></m:EstimationDetails></SOAP-ENV:Body></SOAP-ENV:Envelope>"
    }
    
    
}
