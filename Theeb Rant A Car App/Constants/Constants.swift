//
//  Constants.swift
//  Theeb Rant A Car App
//
//  Created by Moustafa Gadallah on 24/04/1443 AH.
//

import UIKit

var isLanguageChanged = false
enum SOAPACTIONS {
    
    static let IAMServiceWS = "357556369667275635D41494F237375636F62705024727F607D694A336F646"
    static let IAMServiceGetDataWS = "35751647164447567456369667275635D41494F237375636F62705024727F607D694A336F646"
    static let signin = "3575E69476F6C4F237375636F62705024727F607D694A336F646"
    static let driverProfile = "3575275667962744F62705271634F237375636F62705024727F607D694A336F646"
    static let driverUpdate =  "357556C69666F627052756679627444616F6C4F237375636F62705024727F607D694A336F646"
    static let deleteSoap = "3575375747164735275667962744475635F237375636F62705024727F607D694A336F646"
    static let driverMemberShipAction =  "357547E6163696C6070714F237375636F62705024727F607D694A336F646"
    static let vehicleType = "35755607974756C63696865665F237375636F62705024727F607D694A336F646"
    static let priceEstimation = "3575E6F6964716D6964737545636962705F237375636F62705024727F607D694A336F646"
    static let location = "03C213F2563696672756352656752756473716D48636E6162724F2265675F6270747E65625A336F646"
    static let carModel = "3575C65646F6D4271634F237375636F62705024727F607D694A336F646"
    static let reservation = "3575E6F6964716672756375625F62705271634F237375636F62705024727F607D694A336F646"
    static let bookingDetail = "1647164476E696B6F6F624E6F6964716672756375625475674F237375636F62705024727F607D694A336F646"
    static let rentalHistory = "16471644E6F69647361637E6162745475674F237375636F62705024727F607D694A336F646"
    static let payment = "07071456C69626F6D447E656D6971605564716562734F237375636F62705024727F607D694A336F646"
    static let bookingExtend = "966727563526567597669646F6D4E6F69647166727563756252656568645F237375636F62705024727F607D694A336F646"
    static let forgotCancel = "357547563756254627F67737371605275667962744F237375636F62705024727F607D694A336F646"
    static let otpAction = "E6F69647164696C616650545F4275667962744F237375636F62705024727F607D694A336F646"
    static let printDocument = "47E6962705F6270547E65625475674F237375636F62705024727F607D694A336F646"
    static let extras = "03C213F2C6D685E6F6D6D6F634564716562734F237375636F62705024727F607D694A336F646"
    static let alfursanRequest = "3575175625E61637275766C614F62705271634F237375636F62705024727F607D694A336F646"
    static let privacyPolicyEn = "http://52.76.85.106/wp-json/wp/v2/pages/492"
    static let privacyPolicyAr = "http://52.76.85.106/wp-json/wp/v2/pages/493"
    static let rentalAgreementEn = "http://52.76.85.106/wp-json/wp/v2/pages/497"
    static let rentalAgreementAr = "http://52.76.85.106/wp-json/wp/v2/pages/498"
    static let refundPolicyTermsEn = "http://52.76.85.106/wp-json/wp/v2/pages/501"
    static let refundPolicyTermsAr = "http://52.76.85.106/wp-json/wp/v2/pages/502"
    static let termAndConditionEn = "http://52.76.85.106/wp-json/wp/v2/pages/327"
    static let termAndConditionAr = "http://52.76.85.106/wp-json/wp/v2/pages/326"
    static let faqUrl  = "http://52.76.85.106/faq-api.php?lan=en"
    static let MERCHANT_IDENTIFIER = "fnISEZbA"
    static let ACCESS_CODE = "QMYoYvRcz7LhCpHplJZa"
    static let SHA_TYPE = "SHA-256"
    static let SHA_REQUEST_PHRASE = "Super3391Theeb"
    
    static let SHA_RESPONSE_PHRASE = "Super3391Theeb"
    static let CURRENCY_TYPE = "SAR"
    static let LANGUAGE_TYPE = "en"
    static let MERCHANT_EMAIL = "bharat.senwal@theeb.sa"
    static let linkMisc = "http://52.76.85.106/F"
    static let domainForPaymentTest = "https://sbpaymentservices.payfort.com/FortAPI/paymentApi" // Test
   // static let domainForPayment = "https://paymentservices.payfort.com/FortAPI/paymentApi" // Live

    static let domainForPayment = "https://paymentservices.payfort.com/FortAPI/paymentApi" // Test
    
    //case domainForPayment = "https://paymentservices.payfort.com/FortAPI/paymentApi" // Live
    
}

enum BaseURL {
    //static let test = "http://81.21.59.235/Magic94Scripts/mgrqispi94.dll"
    static let test = "https://online.theeb.sa/Magic94Scripts/mgrqispi94.dll"
    static let  offers  = "http://dev.theebsaudia.com/wp-json/wp/v2/offers"
    static let staging = "https://online.theeb.sa/Magic94Scripts/mgrqispi94.dll"
    static let production = "https://online.theeb.sa/Magic94Scripts/mgrqispi94.dll"
    //"https://online.theeb.sa/Magic94Scripts/mgrqispi94.dll"
    static let BaseUrlPriceEstimation = "https://online.theeb.sa/RentPro.Server/Services.aspx"
    static let  BaseUrlPriceEstimationTest = "https://online.theeb.sa/RentPro.Server/Services.aspx"
    static let EhsanPrePro = "https://api.ihsan.sa"
    static let EhsanProd = "https://api.ihsan.sa"
    
   //    static let production = "http://81.21.59.235/Magic94Scripts/mgrqispi94.dll"

}

enum StoryBoards {
    
    static let  LoginRegister = "LoginRegister"
    static let Login  = "Login"
    static let Register = "Register"
    static let CreatePassword = "CreatePassword"
    static let LandingPage = "LandingPage"
    static let  SlideMenuVC  = "SideMenu"
    static let  UserProfile = "UserProfile"
    static let MapLocationView = "MapLocationView"
    static let MyRentalHistory = "MyRetalHistory"
    static let Fleet = "Fleet"
    static let Popup = "Popup"
    static let Checkout = "Checkout"
    static let More = "More"
    static let Home = "Home"
    static let Bills =  "Bills"
    static let Payment = "Payment"
}

enum CountryCodes {
    
    static let saudiArabia = "SA"
}
enum MapMarkerIcon {
    
    static let defaultMarkerIconName = "MapLogo"
    static let selectedMarkerIconName = "logo"
}


enum MinEntryDigits {
    
    static let Mobile = 13
    static let Passport = 8
    static let DocumentId = 8
    static let ResidencyNumber = 10
    static let OTP = 1
}

enum ForgetPasswordOperations {
   
    static let Reset = "R"
    static let Validate = "V"
    static let Save = "S"
}



enum EhsanAPIS {
   
    static let GetToken = "https://api.ihsan.sa/api/app/connect/token"
    static let GetIntiatives = "https://api.ehsan.sa/app/InitiativeTypes/QuickDonation"
    static let Donate = "https://api.ihsan.sa/api/app/donation/ExternalQuickDonation"
    
  
}

enum EhsanCredentials {
    
  static let ClientId = "Theeb_Test"
  static let SectetId = "14d7dc1f-4d26-4d53-ac9f-5b681660b7fa"
    static let GrantType = "client_credentials"
    
}

enum  TrueAndFalse {

    static let TRUE = "True"
    static let FAlse = "False"

}


enum Fonts {
    
    static let CairoBlack = "Cairo-Black"
    static let CairoBold = "Cairo-Bold"
    static let CairoExtraLight = "Cairo-ExtraLight"
    static let CairoLight = "Cairo-Light"
    static let CairoRegular = "Cairo-Regular"
    static let CairoSemiBold = "Cairo-SemiBold"
    static let MontserratBlack = "Montserrat-Black"
    static let MontserratBold = "Montserrat-Bold"
    static let MontserratExtraLight = "Montserrat-ExtraLight"
    static let MontserratLight = "Montserrat-Light"
    static let MontserratMedium = "Montserrat-Medium"
    static let MontserratRegular = "Montserrat-Regular"
    static let MontserratSemiBold = "Montserrat-SemiBold"
    static let BahijTheSansArabicSemiBold = "Bahij TheSansArabic-SemiBold"
    static let BahijTheSansArabicBold = "Bahij TheSansArabic-Bold"
    static let BahijTheSansArabicPlain = "Bahij TheSansArabic-Plain"
}

enum CachingKeys {
    
    static let LoggedInUserData = "LoggedInUserData"
    static let DriverProfileRS = "DriverProfileRS"
    static let Locations = "LocationsKey"
    static let CarModels = "CarModels"
    static let VechileTypes = "VechileTypes"
    static let MakeNames = "MakeNames"
    static let AlforsanID = "AlforsanID"
    static let RoyaltyPointBal = "royaltyPointBal"
    static let isFirstLogin = "isFirstLogin"
    static let email  = "email"
    static let password = "storedPassword"
    static let faceIDenabled = "password"
    static let memberDriverModel = "MemberDriverModel"
    static let EhsanToken = "EhsanToken"
    static let Notifications = "Notifications"
    static let NotificationsDeviceToken = "NotificationsDeviceToken"
    static let NotificationsTitleAndBody = "NotificationsTitleAndBody"

    static let PriceEstimateCDP = "CDP"
    
    static let token = "storedToken"
}

enum BookingsStatuses {
    
    static let Confirmed = "Confirmed"
    static let Cancelled = "Cancelled"
    static let Open = "Open"
}

enum MemberType{
  case bronz,gold,silver,green,diamond
}

enum DateFormats {
    static let APIRecievedLongDateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    static let APILongDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let APIFullRecievedDate = "yyyy-MM-dd'T'HH:mm:ssZ"
    static let DateOnly = "dd/MM/yyyy"
    static let DateAndTime = "dd/MM/yyyy - hh:mm a"
    static let TimeOnly = "hh:mm"
    static let FullDate = "EEEE, MMMM dd 'at' hh:mm a"
    static let FullDatee = " MMMM dd "
    static let FullDateex = " MMMM dd yyyy "
    static let PaymentCardDate = "MM/yy"
}

enum TabBarItems: Int {
    
    case Explore = 0
    case MyRental = 1
    case Profile = 2
    case More = 3
}


enum AlphaStyles {
    
    static let enabled: CGFloat = 1.0
    static let disabled: CGFloat = 0.4
    static let transparent: CGFloat = 0.8
    static let hidden: CGFloat = 0
}

enum TransactionsType {
    
    static let Invoices = "I"
    static let Payments = "P"
    static let Reservations  = "R"
    static let Agreements = "A"
}



 enum MethodLiveCredentials: String{
    
    case payfort = "sgfsbf"
    case linkMisc = "http://www.theebonline.com/"
    
    //About Us
    case engAboutUs = "wp-json/wp/v2/pages/24"
    case arabicAboutUs = "wp-json/wp/v2/pages/22"
    //FAQs
    case engFAQs = "faq-api.php?lan=en"
    case arabicFAQs = "faq-api.php?lan=ar"
    // PrivacyPolicy
    case enPrivacyPolicyFAQs = "wp-json/wp/v2/pages/492"
    case arPrivacyPolicyFAQs = "wp-json/wp/v2/pages/493"
    
    // Rental Agreement
    case enRentalPolicy = "wp-json/wp/v2/pages/497"
    case arRentalPolicy = "wp-json/wp/v2/pages/498"
    
    // Refund and Cancellation Policy :
    case enRefundPolicy = "wp-json/wp/v2/pages/501"
    case arRefundPolicy = "wp-json/wp/v2/pages/502"
    
    
    // Terms and condition :
    case enTermsAndCondition = "wp-json/wp/v2/pages/327"
    case arTermsAndCondition = "wp-json/wp/v2/pages/326"
    
    
    case faqUrl  = "http://www.theebonline.com/faq-api.php?lan=en"
    
     case MERCHANT_IDENTIFIER = "kPLAlPIB"
     case ACCESS_CODE = "X9lo22QC5ewzrfE8Qptz"
 //   case MERCHANT_IDENTIFIER = "fnISEZbA"
  //  case ACCESS_CODE = "QMYoYvRcz7LhCpHplJZa"
    case SHA_TYPE = "SHA-256"
   // case SHA_REQUEST_PHRASE = "TESTSHAIN"
     case SHA_REQUEST_PHRASE = "Super3391Theeb"
     
    case CURRENCY_TYPE = "SAR"
    case LANGUAGE_TYPE = "en"
    case MERCHANT_EMAIL = "bharat.senwal@theeb.sa"
    case WS_GET_TOKEN = "https://sbpaymentservices.payfort.com/FortAPI/paymentApi\""
    
  
    case APPLE_PAY_ACCESS_CODE = "VApZgs3SBHRlC50TWS6h"
    case APPLE_PAY_SHAREQUESTPHRASE_CODE = "80yc4JWrJQbsmGtm7Z4SPO[)"
    case APPLE_PAY_SHARESPONSEPHRASE_CODE = "51g/POVRKwzn4A4Bc8ZMIY+*"
    
    
}


enum CardTypes: Int {
    
    case Paid = 320
    case NAPS = 321
    case KNET = 322
    case AMEX = 324
    case Network = 325
    case Maestro = 326
    case Electron = 327
    case American = 328
    case Master = 329
    case Visa = 330
    case MADA = 331
}


enum PaymentMethods: Int {
    
    case card = 291
    case applePay = 294
}

enum PrintModes {
    
    static let  reservation  = "R"
    static let payment = "P"
    static let invoice = "I"
}

enum AnalyticsKeys {
    
    static let Dashboard = "Dashboard"
    static let SelectBranch = "SelectBranch"
    static let SelectDate = "SelectDate"
    static let SelectTime = "SelectTime"
    static let CarsList = "CarsList"
    static let CarDetails = "CarDetails"
    static let Checkout = "Checkout"
    static let ReservationSuccess = "ReservationSuccess"
    static let FilterCarBrand  = "FilterCarBrand"
    static let FilterCarYear = "FilterCarYear"
    static let FilterCarPrice = "FilterCarPrice"
    static let MyRentals = "MyRentals"
    static let RentalDetails = "RentalDetails"
    static let Payment = "Payment"
    static let Profile = "Profile"
    static let EditProfile = "EditProfile"
    static let ResetPassword = "ResetPassword"
    static let Bills = "Bills"
    static let TransferPoints =  "TransferPoints"
    static let MyMembership = "MyMembership"
    static let RequestMembership = "RequestMembership"
    static let More = "More"
    static let CarFleet  = "CarFleet"
    static let TheebBranches = "TheebBranches"
    static let OurServices = "OurServices"
    static let OurMemberships = "OurMemberships"
    static let  HelpAndSupport = "HelpAndSupport"
    static let  AboutTheeb = "AboutTheeb"
    static let PrivacyPolicy = "PrivacyPolicy"
    static let Settings = "Settings"
    static let Login = "Login"
    static let Register = "Register"
    static let Opt = "Opt"
    static let SetPassword = "SetPassword"
    static let ForgotPassword = "ForgotPassword"
    static let BiometricLogin = "BiometricLogin"
    static let OnBoarding = "OnBoarding"
    
}


class LocalizedImage{
    let iconBackImage = UIImage(named: "iconBack")
    let iconBackImgArabic = UIImage(named: "iconBack")?.flipHorizontally()
    
     func localizedBackImg()->UIImage?{
        return UIApplication.isRTL() ? iconBackImgArabic:iconBackImage
    }
}

var outTime24 = ""
var inTime24 = ""
