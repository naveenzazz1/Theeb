//
//  EndPoint.swift
//  SupportI
//

import Foundation
import UIKit

// MARK: - ...  Network layer configration

struct NetworkConfigration {
    static var urlString = "https://carprouat.theeb.sa:8080/WebAPI/api/"
//    static var urlString:String = "https://api.theeb.sa/WebAPI/api/"
//    static var alfursanUrlString = "https://api.theeb.sa/WebAPI/api/"//"https://carprouat.theeb.sa:8080/WebAPI/api/"
    static var alfursanUrlString = "https://carprouat.theeb.sa:8080/WebAPI/api/"
    static var imageURL = "https://www.theebonline.com/carimages/"
    //static var pushNotificationUrl = "https://saasuat.theeb.sa:8443/"
    static var pushNotificationUrl = "https://theebapi.theeb.sa:4443/"
    
    
    // MARK: - ...  The Endpoints
    
    public enum EndPoint: String {
        case login
        case accessToken
        case resetPassword
        case createAccount
        case yaqeenValidation
        case cancelBooking
        case reservationHistory
        case trasactionData
        case getInsurence
        case getExtras
        case priceEstimation
        case createReservation
        case profile
        case driverInvoices
        case branches
        case carGroup
        case vehicleType
        case getPrintDocument
        case createPayment
        case deleteUser
        var rawValue: String {
            get {
                switch self {
                case .login:
                    return "DriverLoginWS"
                case .accessToken:
                    return "AccessToken"
                case .resetPassword:
                    return "DriverPasswordResetWS"
                case .createAccount:
                    return "DriverRequestAPI"
                case .yaqeenValidation:
                    return "DriverVerification"
                case .cancelBooking:
                    return "CalculateResCancellationFee"
                case .reservationHistory:
                    return "GetBookingData"
                case .trasactionData:
                    return "GetTransactionData"
                case .getInsurence:
                    return "GetInsurance"
                case .getExtras:
                    return "GetExtra"
                case .priceEstimation:
                    return "NewPriceEstimationWS"
                case .createReservation:
                    return "ReservationAPIWS"
                case .profile:
                    return "LoadDriverProfile"
                case .driverInvoices:
                    return "DriverInvoicesWS"
                case .branches:
                    return "GetBranches"
                case .carGroup:
                    return "CarGroup"
                case .vehicleType:
                    return "GetVehicleType"
                case .getPrintDocument:
                    return "GetPrintDocument"
                case .createPayment:
                    return "CreatePayment"
                case .deleteUser:
                    return "DriverLoginStatusWS"
                }
            }
        }
    }
    
    
    
    public enum PushNotificationEndPoint: String {
        case FcmToken
        case accessToken
        case notificationHistory
        var rawValue: String {
            get {
                switch self {
                case .FcmToken:
                    return "FCMToken"
                case .accessToken:
                    return "Token"
                case .notificationHistory:
                    return "GetHistoryofnotifications"
                }
            }
        }
    }
    
    public enum AlforsanEndPoint: String {
        case validateElforsan
        case accessToken
        case convertLoyalityPoints
        case alfoursanHistory
        var rawValue: String {
            get {
                switch self {
                case .accessToken:
                    return alfursanUrlString + "AccessToken"
                case .validateElforsan:
                    return alfursanUrlString + "validatemembershipno"
                case .convertLoyalityPoints:
                    return alfursanUrlString + "convertloyaltypoints"
                case .alfoursanHistory:
                    return alfursanUrlString + "convertloyaltypointslog"
                }
            }
        }
    }
}




extension NetworkConfigration.EndPoint {
    static func endPoint(point: NetworkConfigration.EndPoint, paramters: [Any]? = nil) -> String {
        let method = NewNetworkManager.instance.slugs(point)
        return method
    }
}


 
