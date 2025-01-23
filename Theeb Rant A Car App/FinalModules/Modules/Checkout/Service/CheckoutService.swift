//
//  CheckoutService.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 02/08/1443 AH.
//

import UIKit

class CheckoutService {
    
    func getPriceEstgetPriceEstimtion (isCustomLoader:Bool,outBranch: String?
                                         ,inBranch:String?,
                                         outDate: String?,
                                         inDate:String?
                                         ,outTime: String?,
                                         inTime: String?,
                                        carGroup: String?,
                                        selectedInsurance: String?,
                                       insuranceCode: String?,
                                       insuranceQuantity : String?,
                                         vehicleType : String?,
                                         driverCode : String?,
                                         extras:[ExtraListXmlModel?],
                                         success: APISuccess,
                                         failure: APIFailure) {
        
        
        NetworkManager.manager.request(isCustomLoader:false,soapAction: SOAPACTIONS.priceEstimation, xmlString: self.priceEstimationRequest(outBranch: outBranch, inBranch: inBranch, outDate: outDate, inDate: inDate, outTime: outTime, inTime: inTime, carGroup: carGroup, selecteInsurance: selectedInsurance, insuranceCode:insuranceCode,insuranceQuantity:insuranceQuantity, vehicleType: vehicleType, driverCode: CachingManager.loginObject()?.driverCode ,extras: extras), url: BaseURL.BaseUrlPriceEstimation,success: success, failure: failure)
        
    }
    
    func convertArabicDateToEnglish(dateStr:String?)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let date = formatter.date(from: dateStr ?? "") ?? Date()
        return formatter.string(from: date)
    }
    
    func createReservation(firstName : String?,
                           lastName: String?,
                           reservationCode : String?,
                           outBranch: String?,
                           inBranch:String?,
                           outDate: String?,
                           inDate:String?,
                           outTime: String?,
                           inTime: String?,
                           vehicleType : String?,
                           driverCode : String?,
                           driverLicenseNumber: String?,
                           cdp:String?,rateNo: String?,
                           rentalSum: String?,
                           carGroup : String?,
                           insuranceCode: String?,
                           insuranceQuantity:String?,
                           extras:[ExtraListXmlModel?],
                           success: APISuccess,
                           failure: APIFailure) {
        
        let arabictimeIn = convertArabicDateToEnglish(dateStr: inTime)
        let arabictimeOut = convertArabicDateToEnglish(dateStr: outTime)
        NetworkManager.manager.request(soapAction: SOAPACTIONS.reservation, xmlString: self.carReservationRequestEnvelop(reservationCode: reservationCode, outBranch: outBranch, inBranch: inBranch, outDate: outDate, inDate: inDate, outTime: arabictimeOut, inTime: arabictimeIn, vehicleType: vehicleType, driverCode: driverCode, driverLicenseNumber: driverLicenseNumber, cdp: cdp, rateNo: rateNo, rentalSum: rentalSum, carGroup: carGroup, insuranceCode: insuranceCode, insuranceQuantity: insuranceQuantity, extras: extras), url: BaseURL.production,success: success, failure: failure)
        
    }
    
    
    func priceEstimationRequest(outBranch: String?,
                                inBranch:String?,
                                outDate: String?,
                                inDate:String?,
                                outTime: String?,
                                inTime: String?,
                                carGroup: String?,
                                selecteInsurance : String?,
                                insuranceCode : String?,
                                insuranceQuantity: String?,
                                vehicleType : String?,
                                driverCode : String? ,
                                extras:[ExtraListXmlModel?]) -> String? {
        var extrs = String()
        
        
        if extras.count > 0 {
            for obj in extras
            {
                
                extrs.append("<car:Extra><car:Code>\(obj?.code ?? "")</car:Code><car:Name></car:Name><car:Quantity>\(obj?.count ?? "1")</car:Quantity></car:Extra>")
                
            }
            
        }else {
                extrs.append("<car:Extra><car:Code></car:Code><car:Name></car:Name><car:Quantity></car:Quantity></car:Extra>")
            }
            

        
      

        return "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:car=\"CarproPriceEstimation\"><soapenv:Header/><soapenv:Body><car:EstimationDetails><car:Price><car:CDP></car:CDP><car:OutBranch>\(outBranch ?? "")</car:OutBranch><car:InBranch>\(inBranch ?? "" )</car:InBranch><car:OutDate>\(outDate ?? "")</car:OutDate><car:OutTime>\(outTime ?? "")</car:OutTime><car:InDate>\(inDate ?? "")</car:InDate><car:InTime>\(inTime!)</car:InTime><car:CarGroup></car:CarGroup><car:Currency>SAR</car:Currency><car:DebitorCode></car:DebitorCode><car:VoucherType></car:VoucherType><car:VoucherNo></car:VoucherNo><car:VEHICLETYPE>\(vehicleType ?? "")</car:VEHICLETYPE><car:Booked>\(extrs)<car:Insurance><car:Code>\(insuranceCode ?? "")</car:Code><car:Name>\(selecteInsurance ?? "")</car:Name><car:Quantity>\(insuranceQuantity ?? "")</car:Quantity></car:Insurance></car:Booked><car:DriverCode>\(driverCode ?? "")</car:DriverCode></car:Price></car:EstimationDetails></soapenv:Body></soapenv:Envelope>"
   
    }
    
    
    
     func carReservationRequestEnvelop(firstName : String? = CachingManager.loginObject()?.firstName,
                                            lastName: String?  = CachingManager.loginObject()?.lastName,
                                            reservationCode : String?,
                                            outBranch: String?,
                                            inBranch:String?,
                                            outDate: String?,
                                            inDate:String?,
                                            outTime: String?,
                                            inTime: String?,
                                            vehicleType : String?,
                                            driverCode : String?,
                                            driverLicenseNumber: String?,
                                            cdp:String?,
                                            rateNo: String?,
                                            rentalSum: String?,
                                            carGroup : String?,
                                            insuranceCode: String?,
                                            insuranceQuantity:String?,
                                            extras:[ExtraListXmlModel?]) -> String?
    {
        
     
        
        var extrsXml = String()
        if extras.count > 0 {
            for obj in extras {
                
                extrsXml.append("<car:Extra><car:Code>\(obj?.code ?? "")</car:Code><car:Name>\(obj?.englishName ?? "")</car:Name><car:Quantity>\(obj?.count ?? "1")</car:Quantity></car:Extra>")
                
            }
        }
        

     
      
        
        return  "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:car=\"CarProReservation\"><soapenv:Header/><soapenv:Body><car:ReservationDetails><car:Reservation><car:DriverCode>\(CachingManager.loginObject()?.driverCode ?? "")</car:DriverCode><car:LicenseNo>\(CachingManager.loginObject()?.licenseNo ?? "")</car:LicenseNo><car:LastName>\(CachingManager.loginObject()?.lastName ?? "")</car:LastName><car:FirstName>\(CachingManager.loginObject()?.firstName ?? "")</car:FirstName><car:CDP>\(cdp ?? "")</car:CDP><car:OutBranch>\(outBranch ?? "")</car:OutBranch><car:InBranch>\(inBranch ?? "")</car:InBranch><car:OutDate>\(outDate ?? "")</car:OutDate><car:OutTime>\(outTime ?? "")</car:OutTime><car:InDate>\(inDate ?? "")</car:InDate><car:InTime>\(inTime ?? "")</car:InTime><car:RateNo>\(rateNo ?? "")</car:RateNo><car:RentalSum>\("")</car:RentalSum><car:DepositAmount></car:DepositAmount><car:ReservationNo>\(reservationCode ?? "")</car:ReservationNo><car:ReservationStatus>N</car:ReservationStatus><car:CarGroup>\(carGroup ?? "")</car:CarGroup><car:Currency>SAR</car:Currency><car:PaymentType></car:PaymentType><car:CreditCardNo></car:CreditCardNo><car:CarMake></car:CarMake><car:CarModel></car:CarModel><car:Remarks>IOS-APP</car:Remarks><car:Booked><car:Insurance><car:Code>\(insuranceCode ?? "")</car:Code><car:Name></car:Name><car:Quantity>\(insuranceQuantity ?? "")</car:Quantity></car:Insurance>\(extrsXml )</car:Booked><car:included><car:Insurance><car:Code>\("")</car:Code><car:Name>\("")</car:Name><car:Quantity>\("")</car:Quantity></car:Insurance><car:Extra><car:Code>?</car:Code><car:Name>\("")</car:Name><car:Quantity>\("")</car:Quantity></car:Extra></car:included></car:Reservation></car:ReservationDetails></soapenv:Body></soapenv:Envelope>"
    }
    
    class func priceEstimationRequest() -> String? {
        return "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:car=\"CarproPriceEstimation\"><soapenv:Header/><soapenv:Body><car:EstimationDetails UserId=\"?\" UserPassword=\"?\"><car:Price><car:CDP>?</car:CDP><car:InBranch></car:InBranch><car:OutBranch></car:OutBranch><car:OutDate></car:OutDate><car:OutTime></car:OutTime><car:InDate></car:InDate><car:InTime></car:InTime><car:CarGroup>ALL</car:CarGroup><car:Currency>SAR</car:Currency><car:DebitorCode>?</car:DebitorCode><car:VoucherType>?</car:VoucherType><car:VoucherNo>?</car:VoucherNo><car:VEHICLETYPE>?</car:VEHICLETYPE><car:Booked><car:Insurance><car:Code>?</car:Code><car:Name>?</car:Name><car:Quantity>?</car:Quantity></car:Insurance><car:Extra><car:Code>?</car:Code><car:Name>?</car:Name><car:Quantity>?</car:Quantity></car:Extra></car:Booked></car:Price></car:EstimationDetails></soapenv:Body></soapenv:Envelope>"
}
    
}
