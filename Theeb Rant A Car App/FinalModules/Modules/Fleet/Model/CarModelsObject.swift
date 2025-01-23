//
//  CarModelsObject.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 12/07/1443 AH.
//

import Foundation
import XMLMapper

class CarModelBaseObject: XMLMappable {
    
    var nodeName: String!
    var soapEnvelopeOuter : [CarModelObject]?
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        soapEnvelopeOuter <- map["SOAP-ENV:Body.CarModel.Model"]
    }
    
    
}

class CarModelObject: XMLMappable , Codable {
    var nodeName: String!
    
    var group : String!
    var vehTypeDesc : String!
    var imageUrl : String!
    var vTHCode : String!
    var vTHDesc : String!
    var vTHType : String!
    var price : Double?
    var makeName : String? = ""
    var modelName : String? = ""
    var modelTransmissionDesc : String? = ""
    var modelFuelDesc : String? = ""
    var modelFuelTankVolume : String? = ""
    var modelNoOfPassenger : String? = ""
    var modelNoOfDoors : String? = ""
    var modelGpsAvaliable : String? = ""
    var canSmoke : String? = ""
    var vTHDescAr : String!
    var modelVersion: String!
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        group <- map["Group"]
        modelVersion <- map["ModelVersion"]
        vehTypeDesc <- map["VehTypeDesc"]
        imageUrl <- map["ImageUrl"]
        vTHCode <- map["VTHCode"]
        vTHDesc <- map["VTHDesc"]
        vTHType <- map["VTHType"]
        makeName <- map["MakeName"]
        modelName <- map["ModelName"]
        modelTransmissionDesc <- map["ModelTransmissionDesc"]
        modelFuelDesc <- map["ModelFuelDesc"]
        modelFuelTankVolume <- map["ModelFuelTankVolume"]
        modelNoOfPassenger <- map["ModelNoOfPassenger"]
        modelNoOfDoors <- map["ModelNoOfDoors"]
        modelGpsAvaliable <- map["ModelGpsAvaliable"]
        canSmoke <- map["CanSmoke"]
        vTHDescAr <- map["VTHDescription"]
        
    }
    
    
}


class PriceResponseBaseModel: XMLMappable {
    
    var nodeName: String!
    
    var debitorCode : String?
    var cDP : String?
    var voucherType : String?
    var voucherCode : String?
    var carGroup : String?
    var currency : String?
    var outBranch : String?
    var inBranch : String?
    var outDate : String?
    var outTime  : String?
    var inDate : String?
    var inTime : String?
    var status : String?
    var rateNo :String?
    var carGroupModel :[CarGroupModel]?
    var success: String!
    var varianceReason : String!
    var insuranceModel : InsuranceModel!
    var vthDesc : String?
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        
        debitorCode <- map["DebitorCode"]
        cDP <- map["CDP"]
        voucherType <- map["VoucherType"]
        voucherCode <- map["VoucherType"]
        carGroup <- map.attributes["carGrop"]
        currency <- map["Currency"]
        outBranch <- map["OutBranch"]
        inBranch <- map["InBranch"]
        outDate <- map["OutDate"]
        outTime <- map["OutTime"]
        inDate <- map["InDate"]
        inTime <- map["InTime"]
        status <- map["Status"]
        rateNo <- map["RateNo"]
        carGroupModel <- map["CarGroupPrice"]
        success <- map["Success"]
        insuranceModel <- map["Insurance"]
        varianceReason <- map["VarianceReason"]
        vthDesc <- map["VTHDescription"]
    
    }
    
    
}


class InsuranceModel: XMLMappable {
    var nodeName: String!
    
    var insuranceAmount : String!
    var insuranceCode : String!
    var insuranceIncludedYN : String!
    var insuranceQuantity : String!
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        insuranceAmount <- map.attributes["Amount"]
        insuranceCode <- map.attributes["Code"]
        insuranceIncludedYN <- map.attributes["IncludedYN"]
        insuranceQuantity <- map.attributes["Quantity"]
    }
    
    
}
class CarGroupModel: XMLMappable {
    var nodeName: String!
    
    var rateNO : String?
    var rateName : String?
    var ratePackage : String?
    var ratePackageDays : String?
    var ratePackagePrice : String?
    var soldDays : String?
    var rentalSum : String?
    var insuranceSum : String?
    var extrasSum : String?
    var dropffSum : String?
    var airportFee : String?
    var vatPerc : String?
    var vataAmount : String?
    var totalAmount : String?
    var weekendAmount : String?
    var alert : String?
    var vthCode : String?
    var vthDesc : String?
    var carAvailable :String?
    var carGrop :String?
    var carGropIntCode :String?
    var vatWithoutInsurance :String?
    var totalWithoutInsurance :String?
    var discountAmount :String?
    var discountPercentage :String?
    var vthDescCarType : String?
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        rateNO <- map["RateNo"]
        rateName <- map["RateName"]
        ratePackage <- map["RatePackage"]
        ratePackageDays <- map["RatePackageDays"]
        ratePackagePrice <- map["RatePackagePrice"]
        soldDays <- map["SoldDays"]
        rentalSum <- map["RentalSum"]
        insuranceSum <- map["InsuranceSum"]
        extrasSum <- map["ExtrasSum"]
        dropffSum <- map["DropOffSum"]
        airportFee <- map["AirportFee"]
        vatPerc <- map["VATPerc"]
        vataAmount <- map["VATAmount"]
        totalAmount <- map["TotalAmount"]
        weekendAmount <- map["WeekendAmount"]
        alert <- map["Alert"]
        vthCode <- map["VTHCode"]
        vthDesc <- map["VTHDesc"]
        carAvailable <- map["CarAvailable"]
        carGrop <- map.attributes["CarGrop"]
        carGropIntCode <- map["CarGropIntCode"]
        vatWithoutInsurance <- map["VATAmountWOIns"]
        totalWithoutInsurance <- map["TotalAmountWOIns"]
        discountAmount <- map["DiscountAmount"]
        discountPercentage <- map["DiscountPercentage"]
        vthDescCarType <- map["VTHDescription"]
        
    }
    
    
}

class PriceEstimationMappableResponse: XMLMappable {
    var nodeName: String!
    
    var priceResponseModel : PriceResponseModel!
    var success: String!
    var varianceReason : String!
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        success <- map["SOAP-ENV:Body.EstimationDetails.Success"]
        varianceReason <- map["SOAP-ENV:Body.EstimationDetails.VarianceReason"]
        priceResponseModel <- map["SOAP-ENV:Body.EstimationDetails.Price"]
    }
}


class PriceResponseModel: XMLMappable {
    
    var nodeName: String!
    
    var debitorCode : String?
    var cDP : String?
    var voucherType : String?
    var voucherCode : String?
    var carGroup : String?
    var currency : String?
    var outBranch : String?
    var inBranch : String?
    var outDate : String?
    var outTime  : String?
    var inDate : String?
    var inTime : String?
    var status : String?
    var rateNo :String?
    var carGroupModel :[CarGroupModel]?
    var success: String!
    var varianceReason : String!
    var insuranceModel : InsuranceModel!
    var vthDesc : String?
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        
        debitorCode <- map["DebitorCode"]
        cDP <- map["CDP"]
        voucherType <- map["VoucherType"]
        voucherCode <- map["VoucherType"]
        carGroup <- map.attributes["carGrop"]
        currency <- map["Currency"]
        outBranch <- map["OutBranch"]
        inBranch <- map["InBranch"]
        outDate <- map["OutDate"]
        outTime <- map["OutTime"]
        inDate <- map["InDate"]
        inTime <- map["InTime"]
        status <- map["Status"]
        rateNo <- map["RateNo"]
        carGroupModel <- map["CarGroupPrice"]
        success <- map["Success"]
        insuranceModel <- map["Insurance"]
        varianceReason <- map["VarianceReason"]
        vthDesc <- map["VTHDescription"]
        
    }
    
    
}


class PriceEstimationMappable: XMLMappable {
    var nodeName: String!
    
    var soapEnvelopeOuter : EstimationModel!
//    var outBranch : Branch!
//    var inBranch : Branch!
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        soapEnvelopeOuter <- map["soapenv:Body.car:EstimationDetails"]
    }
    
    
}

class EstimationModel: XMLMappable {
    var nodeName: String!
    
    var userID : String!
    
    var userPassword : String!
    
    var carPriceModel : CarPriceModel!
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        userID <- map["car:UserId"]
        userPassword <- map["car:UserPassword"]
        carPriceModel <- map["car:Price"]
    }
    
    
}

class CarPriceModel: XMLMappable {
    var nodeName: String!
    
    var CDP : String!
    var InBranch : String!
    var OutBranch    : String!
    var OutBranchName : String!
    var InBranchName : String!
    var OutDate : String!
    var OutTime : String!
    var InDate : String!
    var InTime : String!
    var CarGroup : String!
    var DebitorCode : String!
    var VoucherType : String!
    var VoucherNo : String!
    var VEHICLETYPE : String!
    var Currency : String!
    
    var BookedInsurance : InsuranceExtraModel!
    var BookedExtra : InsuranceExtraModel!
    
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        CDP <- map["car:CDP"]
        InBranch <- map["car:InBranch"]
        OutBranch <- map["car:OutBranch"]
        OutDate <- map["car:OutDate"]
        OutTime <- map["car:OutTime"]
        InDate <- map["car:InDate"]
        InTime <- map["car:InTime"]
        CarGroup <- map["car:CarGroup"]
        DebitorCode <- map["car:DebitorCode"]
        VoucherType <- map["car:VoucherType"]
        VoucherNo <- map["car:VoucherNo"]
        VEHICLETYPE <- map["car:VEHICLETYPE"]
        Currency <- map["car:Currency"]
        BookedInsurance <- map["car:Booked.car:Insurance"]
        BookedExtra <- map["car:Booked.car:Extra"]
        
        
    }
    
    
}

class InsuranceExtraModel: XMLMappable {
   
    var nodeName: String!
    
    var code     : String!
    var quantity : String!
    var name : String!
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        code <- map["car:Code"]
        quantity <- map["car:Quantity"]
        name <- map["car:Name"]
    }
    
    
}

class VehTypeModel: XMLMappable , Codable  {
    var nodeName: String!

    var code : String!
    var desc : String!
    var type : String!
    var isSelected : Bool? = false
    var description_2 : String!

    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        
        code  <- map["Code"]
        desc <- map["Desc"]
        type <- map["Type"]
         description_2 <- map["Description_2"]
    }
  
}

class VehicleTypeXmlMappable: XMLMappable {
    
    var nodeName: String!
    var soapEnvelopeOuter : VehicleElementModel?
    
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        soapEnvelopeOuter <- map["SOAP-ENV:Body.VehicleTypes"]
    }
    
    
}

class VehicleElementModel: XMLMappable {
    var nodeName: String!
    
    var vehicleTypeModel : [VehTypeModel]!
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        vehicleTypeModel <- map["VehType"]
    }
    
    
}


class Brand : Codable{
    
    
    var isSelected: Bool? = false
    var makeName : String?
}


class YearFilterModel: Equatable{
    static func == (lhs: YearFilterModel, rhs: YearFilterModel) -> Bool {
        return lhs.modelYear == rhs.modelYear && lhs.isSelected == rhs.isSelected
    }
    
    
    
    var isSelected: Bool? = false
    var modelYear : String?
    
    required init(modelYear: String, isSelected: Bool) {
           self.modelYear = modelYear
        self.isSelected = isSelected
       }
    
}

struct PriceEstimationMappableResponseJson : Codable {
    let estimationDetails : EstimationDetails?

    enum CodingKeys: String, CodingKey {

        case estimationDetails = "EstimationDetails"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        estimationDetails = try values.decodeIfPresent(EstimationDetails.self, forKey: .estimationDetails)
    }

}

struct EstimationDetails : Codable {
    let success : String?
    let varianceReason : String?
    let price : PriceJson?

    enum CodingKeys: String, CodingKey {

        case success = "Success"
        case varianceReason = "VarianceReason"
        case price = "Price"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(String.self, forKey: .success)
        varianceReason = try values.decodeIfPresent(String.self, forKey: .varianceReason)
        price = try values.decodeIfPresent(PriceJson.self, forKey: .price)
    }

}

struct PriceJson : Codable {
    let debitorCode : String?
    let cDP : String?
    let voucherType : String?
    let voucherCode : String?
    let carGroup : String?
    let currency : String?
    let outBranch : String?
    let inBranch : String?
    let outDate : String?
    let outTime : String?
    let inDate : String?
    let inTime : String?
    let status : String?
    let varianceReason : String?
    let carGroupPrice : [CarGroupPrice]?
    let insurance : [Insurance]?

    enum CodingKeys: String, CodingKey {

        case debitorCode = "DebitorCode"
        case cDP = "CDP"
        case voucherType = "VoucherType"
        case voucherCode = "VoucherCode"
        case carGroup = "CarGroup"
        case currency = "Currency"
        case outBranch = "OutBranch"
        case inBranch = "InBranch"
        case outDate = "OutDate"
        case outTime = "OutTime"
        case inDate = "InDate"
        case inTime = "InTime"
        case status = "Status"
        case varianceReason = "VarianceReason"
        case carGroupPrice = "CarGroupPrice"
        case insurance = "Insurance"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        debitorCode = try values.decodeIfPresent(String.self, forKey: .debitorCode)
        cDP = try values.decodeIfPresent(String.self, forKey: .cDP)
        voucherType = try values.decodeIfPresent(String.self, forKey: .voucherType)
        voucherCode = try values.decodeIfPresent(String.self, forKey: .voucherCode)
        carGroup = try values.decodeIfPresent(String.self, forKey: .carGroup)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        outBranch = try values.decodeIfPresent(String.self, forKey: .outBranch)
        inBranch = try values.decodeIfPresent(String.self, forKey: .inBranch)
        outDate = try values.decodeIfPresent(String.self, forKey: .outDate)
        outTime = try values.decodeIfPresent(String.self, forKey: .outTime)
        inDate = try values.decodeIfPresent(String.self, forKey: .inDate)
        inTime = try values.decodeIfPresent(String.self, forKey: .inTime)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        varianceReason = try values.decodeIfPresent(String.self, forKey: .varianceReason)
        carGroupPrice = try values.decodeIfPresent([CarGroupPrice].self, forKey: .carGroupPrice)
        insurance = try values.decodeIfPresent([Insurance].self, forKey: .insurance)
    }

}

struct CarGroupPrice : Codable {
    let carGrop : String?
    let carGropIntCode : String?
    let rateNo : String?
    let rateName : String?
    let ratePackage : String?
    var ratePackagePrice : String?
    let soldDays : String?
    let rentalSum : String?
    let insuranceSum : String?
    let extrasSum : String?
    let dropOffSum : String?
    let airportFee : String?
    let deliveryCharge : String?
    let pickupCharge : String?
    let freeKms : String?
    let minimumDeposit : String?
    let vATPerc : String?
    let vATAmount : String?
    let totalAmount : String?
    let weekendAmount : String?
    let alert : String?
    let vTHCode : String?
    let vTHDesc : [String?]?
    let carAvailable : String?
    let tariffCode : String?
    let discountAmount:String?
    let modelInformation : [ModelInformation]?
    

    enum CodingKeys: String, CodingKey {

        case carGrop = "CarGrop"
        case carGropIntCode = "CarGropIntCode"
        case rateNo = "RateNo"
        case rateName = "RateName"
        case ratePackage = "RatePackage"
        case soldDays = "SoldDays"
        case rentalSum = "RentalSum"
        case insuranceSum = "InsuranceSum"
        case extrasSum = "ExtrasSum"
        case dropOffSum = "DropOffSum"
        case airportFee = "AirportFee"
        case deliveryCharge = "DeliveryCharge"
        case pickupCharge = "PickupCharge"
        case freeKms = "FreeKms"
        case minimumDeposit = "MinimumDeposit"
        case vATPerc = "VATPerc"
        case vATAmount = "VATAmount"
        case totalAmount = "TotalAmount"
        case weekendAmount = "WeekendAmount"
        case alert = "Alert"
        case vTHCode = "VTHCode"
        case vTHDesc = "VTHDesc"
        case carAvailable = "CarAvailable"
        case tariffCode = "TariffCode"
        case modelInformation = "ModelInformation"
        case discountAmount = "DiscountAmount"
        case ratePackagePrice = "RatePackagePrice"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        carGrop = try values.decodeIfPresent(String.self, forKey: .carGrop)
        carGropIntCode = try values.decodeIfPresent(String.self, forKey: .carGropIntCode)
        rateNo = try values.decodeIfPresent(String.self, forKey: .rateNo)
        rateName = try values.decodeIfPresent(String.self, forKey: .rateName)
        ratePackage = try values.decodeIfPresent(String.self, forKey: .ratePackage)
        ratePackagePrice = try values.decodeIfPresent(String.self, forKey: .ratePackagePrice)
        soldDays = try values.decodeIfPresent(String.self, forKey: .soldDays)
        rentalSum = try values.decodeIfPresent(String.self, forKey: .rentalSum)
        insuranceSum = try values.decodeIfPresent(String.self, forKey: .insuranceSum)
        extrasSum = try values.decodeIfPresent(String.self, forKey: .extrasSum)
        dropOffSum = try values.decodeIfPresent(String.self, forKey: .dropOffSum)
        airportFee = try values.decodeIfPresent(String.self, forKey: .airportFee)
        deliveryCharge = try values.decodeIfPresent(String.self, forKey: .deliveryCharge)
        pickupCharge = try values.decodeIfPresent(String.self, forKey: .pickupCharge)
        freeKms = try values.decodeIfPresent(String.self, forKey: .freeKms)
        minimumDeposit = try values.decodeIfPresent(String.self, forKey: .minimumDeposit)
        vATPerc = try values.decodeIfPresent(String.self, forKey: .vATPerc)
        vATAmount = try values.decodeIfPresent(String.self, forKey: .vATAmount)
        totalAmount = try values.decodeIfPresent(String.self, forKey: .totalAmount)
        weekendAmount = try values.decodeIfPresent(String.self, forKey: .weekendAmount)
        alert = try values.decodeIfPresent(String.self, forKey: .alert)
        vTHCode = try values.decodeIfPresent(String.self, forKey: .vTHCode)
        vTHDesc = try values.decodeIfPresent([String].self, forKey: .vTHDesc)
        carAvailable = try values.decodeIfPresent(String.self, forKey: .carAvailable)
        tariffCode = try values.decodeIfPresent(String.self, forKey: .tariffCode)
        modelInformation = try values.decodeIfPresent([ModelInformation].self, forKey: .modelInformation)
        discountAmount = try values.decodeIfPresent(String.self, forKey: .discountAmount)

    }

}

struct ModelInformation : Codable {
    let modelName : String?
    let fuelType : String?
    let transmission : String?
    let noOfDoors : String?
    let noOfPasengers : String?
    let engineSize : String?
    let fogLight : String?
    let heatedSeats : String?

    enum CodingKeys: String, CodingKey {

        case modelName = "ModelName"
        case fuelType = "FuelType"
        case transmission = "Transmission"
        case noOfDoors = "NoOfDoors"
        case noOfPasengers = "NoOfPasengers"
        case engineSize = "EngineSize"
        case fogLight = "FogLight"
        case heatedSeats = "HeatedSeats"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        modelName = try values.decodeIfPresent(String.self, forKey: .modelName)
        fuelType = try values.decodeIfPresent(String.self, forKey: .fuelType)
        transmission = try values.decodeIfPresent(String.self, forKey: .transmission)
        noOfDoors = try values.decodeIfPresent(String.self, forKey: .noOfDoors)
        noOfPasengers = try values.decodeIfPresent(String.self, forKey: .noOfPasengers)
        engineSize = try values.decodeIfPresent(String.self, forKey: .engineSize)
        fogLight = try values.decodeIfPresent(String.self, forKey: .fogLight)
        heatedSeats = try values.decodeIfPresent(String.self, forKey: .heatedSeats)
    }

}

struct Insurance : Codable {
    let amount : String?
    let code : String?
    let includedYN : Int?
    let quantity : Int?

    enum CodingKeys: String, CodingKey {

        case amount = "Amount"
        case code = "Code"
        case includedYN = "IncludedYN"
        case quantity = "Quantity"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        includedYN = try values.decodeIfPresent(Int.self, forKey: .includedYN)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
    }

}



// NEW RESPONSES

// Cars

struct CarGroupResponse: Codable {
    var CarGroup: CarGroupMode?
   
}

struct CarGroupMode: Codable {
    let success: String?
    let groups: [CarGroup]?
    
    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case groups = "Group"
    }
}
struct CarGroup: Codable {
    let group: String?
    let carImage: String?
    let vehTypeDesc: String?
    let vthCode: String?
    let vthDesc: String?
    let vthType: String?
    let vthDescription: String?
    let make: String?
    let makeName: String?
    let model: String?
    let modelName: String?
    let modelVersion: String?
    let modelSeries: String?
    let modelTransmission: String?
    let modelTransmissionDesc: String?
    let modelFuelDesc: String?
    let modelFuelTankVolume: String?
    let modelNoOfPassenger: String?
    let modelNoOfDoors: String?
    let modelGpsAvailable: String?
    let canSmoke: String?
    let vehTypeDescAR: String?
    var price: Double?
    
    enum CodingKeys: String, CodingKey {
        case group = "Group"
        case carImage = "CarImage"
        case vehTypeDesc = "VehTypeDesc"
        case vthCode = "VTHCode"
        case vthDesc = "VTHDesc"
        case vthType = "VTHType"
        case vthDescription = "VTHDescription"
        case make = "Make"
        case makeName = "MakeName"
        case model = "Model"
        case modelName = "ModelName"
        case modelVersion = "ModelVersion"
        case modelSeries = "ModelSeries"
        case modelTransmission = "ModelTransmission"
        case modelTransmissionDesc = "ModelTransmissionDesc"
        case modelFuelDesc = "ModelFuelDesc"
        case modelFuelTankVolume = "ModelFuelTankVolume"
        case modelNoOfPassenger = "ModelNoOfPassenger"
        case modelNoOfDoors = "ModelNoOfDoors"
        case modelGpsAvailable = "ModelGpsAvaliable"
        case canSmoke = "CanSmoke"
        case vehTypeDescAR = "VehTypeDescAR"
    }
}


// GetVehicleType


struct VehicleTypesResponseModel: Codable {
    let vehicleTypes : VehicleTypesModel?

    enum CodingKeys: String, CodingKey {

        case vehicleTypes = "VehicleTypes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        vehicleTypes = try values.decodeIfPresent(VehicleTypesModel.self, forKey: .vehicleTypes)
    }

}

struct VehicleTypesModel: Codable {
    let success : String?
    let varianceReason : String?
    let vehType : [VehicleTypeModel]?

    enum CodingKeys: String, CodingKey {

        case success = "Success"
        case varianceReason = "VarianceReason"
        case vehType = "VehType"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(String.self, forKey: .success)
        varianceReason = try values.decodeIfPresent(String.self, forKey: .varianceReason)
        vehType = try values.decodeIfPresent([VehicleTypeModel].self, forKey: .vehType)
    }

}

struct VehicleTypeModel: Codable {
    let code : String?
    let desc : String?
    let type : String?
    let description_2 : String?
    let carGroups : [VehicleCarGroup]?
    var isSelected : Bool? = false


    enum CodingKeys: String, CodingKey {

        case code = "Code"
        case desc = "Desc"
        case type = "Type"
        case description_2 = "Description_2"
        case carGroups = "CarGroups"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        desc = try values.decodeIfPresent(String.self, forKey: .desc)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        description_2 = try values.decodeIfPresent(String.self, forKey: .description_2)
        carGroups = try values.decodeIfPresent([VehicleCarGroup].self, forKey: .carGroups)
    }

}


struct VehicleCarGroup: Codable {
    let carGroupID : String?
    let carGroupName : String?
    let vehicleClassCode : String?
    let vehicleClassName : String?
    let carImage: String?

    enum CodingKeys: String, CodingKey {
        case carImage = "CarImage"
        case carGroupID = "CarGroupID"
        case carGroupName = "CarGroupName"
        case vehicleClassCode = "VehicleClassCode"
        case vehicleClassName = "VehicleClassName"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        carGroupID = try values.decodeIfPresent(String.self, forKey: .carGroupID)
        carGroupName = try values.decodeIfPresent(String.self, forKey: .carGroupName)
        vehicleClassCode = try values.decodeIfPresent(String.self, forKey: .vehicleClassCode)
        vehicleClassName = try values.decodeIfPresent(String.self, forKey: .vehicleClassName)
        carImage = try values.decodeIfPresent(String.self, forKey: .carImage)
    }

}
