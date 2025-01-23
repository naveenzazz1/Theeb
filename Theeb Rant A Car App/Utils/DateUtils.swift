//
//  DateUtils.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 10/07/1443 AH.
//

import UIKit
import Firebase
class DateUtils: NSObject {
    
    
    // MARK: - Variables
    
    static var dateFormatter = DateFormatter()

    
    // MARK: - GetFormated Date
    
    class func GetDateOnlyFromFullDate(originalFormat:String, convertedFormat:String, dateString: String?, timeZone: TimeZone? = nil) -> String? {

        guard let dateString = dateString else { return nil }
        
        let formatter = getDateFormatter(timeZone: timeZone)
        formatter.dateFormat = originalFormat
        
        guard let finalDate = formatter.date(from: dateString) else { return nil }
        
        formatter.dateFormat = convertedFormat
        let finalDateString = formatter.string(from: finalDate)
        
        return finalDateString
    }
    
    class func convertArabicDateToEnglish(arabicDateString: String, inputFormat: String = "MM/dd/yyyy", outputFormat: String = "MM/dd/yyyy") -> String? {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = inputFormat
        inputDateFormatter.locale = Locale(identifier: "ar_SA") // Arabic locale
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = outputFormat
        outputDateFormatter.locale = Locale(identifier: "en_US") // English locale
        
        if let date = inputDateFormatter.date(from: arabicDateString) {
            return outputDateFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
    class func formatArabicDate(date: Date, outputFormat: String = "dd MMMM yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = outputFormat
      //  dateFormatter.locale = Locale(identifier: "en_US") // Arabic locale for output
        return dateFormatter.string(from: date)
    }


    // Function to format Date to the desired English date string format
    class func formatEnglishDate(date: Date, outputFormat: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = outputFormat
        dateFormatter.locale = Locale(identifier: "en_US") // English locale for output
        return dateFormatter.string(from: date)
    }

    
    class func stringFromDate(_ date: Date?, format: String? = DateFormats.DateOnly, timeZone: TimeZone? = nil, local: Locale? = nil) -> String? {
        
        guard let date = date else { return nil }
        
        let dateFormatter = getDateFormatter(timeZone: timeZone, local: local)

        dateFormatter.dateFormat = format
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    class func dateFromString(_ dateString: String?, format: String? = DateFormats.DateOnly, timeZone: TimeZone? = nil) -> Date? {
        
        guard let dateString = dateString else { return nil }

        let dateFormatter = getDateFormatter(timeZone: timeZone)

        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: dateString)
        return date
    }
    
    func dateFromStringV2(_ dateString: String?, format: String? = "dd/MM/yyyy", timeZone: TimeZone? = TimeZone.current) -> Date? {
        guard let dateString = dateString else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            var components = calendar.dateComponents(in: timeZone ?? TimeZone.current, from: date)
            components.hour = 0
            components.minute = 0
            components.second = 0
            return calendar.date(from: components)
        }
        return nil
    }
    
    class func getDateFormatter(timeZone: TimeZone? = nil, local: Locale? = nil) -> DateFormatter {
        let isArabic = UIApplication.isRTL()

        
        dateFormatter.locale = (local != nil ) ? local : Locale(identifier: isArabic ? "en_US":"en_US")
        
        if let timeZone = timeZone {
            
            dateFormatter.timeZone = timeZone
        }
        
        return dateFormatter
    }
    
    class func convertToUTCDate(dateString: String?, originalFormat: String? = DateFormats.DateOnly) -> String? {
        
        let formatter = getDateFormatter()
        formatter.dateFormat = originalFormat
       
        guard let localDate = dateFromString(dateString, format: originalFormat) else { return dateString }
        
        let timeZoneOffset: TimeInterval = TimeInterval(NSTimeZone.default.secondsFromGMT())
        let utcTimeInterval: TimeInterval = localDate.timeIntervalSinceReferenceDate - timeZoneOffset
        
        let utcCurrentDate = Date(timeIntervalSinceReferenceDate: utcTimeInterval)
        let utcDate = formatter.string(from: utcCurrentDate)
        return utcDate
    }
    
    class func utcTimeZone() -> TimeZone? {
    
        return TimeZone(abbreviation: "UTC")
    }
    
    class func getDateDifferenceInHours(start: Date?, end: Date?) -> (Int?, Int? ){
        
        guard let start = start, let end = end else { return (nil, nil) }
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: start, to: end)
        let hours = dateComponents.hour
        let minutes = dateComponents.minute

        return (hours, minutes)
    }
    
   class func changeDateFormatFromStringUser(stringDate: String ,formatInput: String , formatOutPut : String) -> String
  {
      let arrStr = Array(stringDate)
      let formatted = "\(arrStr[6])\(arrStr[7])/\(arrStr[4])\(arrStr[5])/\(arrStr[0])\(arrStr[1])\(arrStr[2])\(arrStr[3])"

      return formatted
  }
   
    class func randomAlphaNumericString(length: Int) -> String {
      let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      let allowedCharsCount = UInt32(allowedChars.count)
      var randomString = ""

      for _ in 0 ..< length {
          let randomNum = Int(arc4random_uniform(allowedCharsCount))
          let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
          let newCharacter = allowedChars[randomIndex]
          randomString += String(newCharacter)
      }

      return randomString
  }
  
    class func getIdForUserIAM(bool:Bool?,str:String) -> String?
  {
      if(bool==nil)
      {
          UserDefaults.standard.setValue(str, forKey: "iAMKey")
      }
      else
      {
          return UserDefaults.standard.object(forKey: "iAMKey") as? String
      }
      
   return ""
  }
    
    
    class func getDateComponentsFromMilliSeconds(_ milliSeconds : Double) -> DateComponents? {
          
        let seconds = milliSeconds / 1000
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day, .hour], from: Date(), to: Date().addingTimeInterval(TimeInterval(seconds)))
        return dateComponents
        
    }
    
    class func getDateComponentsFromSeconds(_ seconds : Int) -> DateComponents {
         
         let calendar = Calendar.current
         let dateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: Date(), to: Date().addingTimeInterval(TimeInterval(seconds)))
         return dateComponents
     }
    
    class func subtractDays(startDate: Date, endDate: Date) -> Int {
        
        let dateComponentsFirst = Calendar.current.dateComponents([.day],
                                                                  from: startDate).day ?? 0
        let dateComponentsLast = Calendar.current.dateComponents([.day],
                                                                 from: endDate).day ?? 0
        return dateComponentsLast - dateComponentsFirst
    }
    
    class func daysBetweenDates(startDate: Date, endDate: Date) -> Int? {
        
        let dateComponents = Calendar.current.dateComponents([.day],
                                                             from: startDate,
                                                             to: endDate)
        return dateComponents.day
    }
    
    class func hoursBetweenDates(startDate: Date, endDate: Date) -> Int? {
        
        let dateComponents = Calendar.current.dateComponents([.hour],
                                                             from: startDate,
                                                             to: endDate)
        return dateComponents.hour
    }
    

//    class func convertPmTo24(time: String) -> String? {
//        let timeComponents = time.components(separatedBy: ":")
//        guard let hour = Int(timeComponents[0]), let minute = Int(timeComponents[1].prefix(2)) else {
//            return nil
//        }
//        var hourIn24HourFormat = hour
//        if time.contains("PM") {
//            hourIn24HourFormat += 12
//        }
//        return String(format: "%02d:%02d", hourIn24HourFormat, minute)
//    }
    
    class func convertPmTo24(time: String) -> String? {
         var convertedTime = time
         
         let arabicNumbers: [String] = ["٠", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩"]
         let westernNumbers: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
         
         for (index, arabicNumber) in arabicNumbers.enumerated() {
             convertedTime = convertedTime.replacingOccurrences(of: arabicNumber, with: westernNumbers[index])
         }
         
         if convertedTime.contains("م") {
             convertedTime = convertedTime.replacingOccurrences(of: "م", with: " PM")
         } else if convertedTime.contains("ص") {
             convertedTime = convertedTime.replacingOccurrences(of: "ص", with: " AM")
         }
         
         let timeComponents = convertedTime.components(separatedBy: " ")
         if timeComponents.count == 3 {
             //        guard timeComponents.count == 3 else {
             //            return nil
             //        }
             
             let time = timeComponents[0]
             let period = timeComponents[2]
             let components = time.components(separatedBy: ":")
             
             guard components.count == 2,
                   let hour = Int(components[0]),
                   let minute = Int(components[1]) else {
                 return ""
             }
             
             var hourIn24HourFormat = hour
             let isPM = period.contains("PM")
             
             if hour == 12 {
                 hourIn24HourFormat = isPM ? 12 : 0
             } else {
                 hourIn24HourFormat += isPM ? 12 : 0
             }
             
             return String(format: "%02d:%02d", hourIn24HourFormat, minute)
         } else if timeComponents.count == 1 {
             let time = timeComponents[0]
             let period = "PM"
             let components = time.components(separatedBy: ":")
             guard components.count == 2,
                   let hour = Int(components[0]),
                   let minute = Int(components[1]) else {
                 return ""
             }
             
             var hourIn24HourFormat = hour
             let isPM = period.contains("PM")
             
             if hour == 12 {
                 hourIn24HourFormat = isPM ? 12 : 0
             } else {
                 hourIn24HourFormat = hour
             }
             
             return String(format: "%02d:%02d", hourIn24HourFormat, minute)
         } else {
             let time = timeComponents[0]
             let period = timeComponents[1]
             let components = time.components(separatedBy: ":")
             
             guard components.count == 2,
                   let hour = Int(components[0]),
                   let minute = Int(components[1]) else {
                 return ""
             }
             
             var hourIn24HourFormat = hour
             let isPM = period.contains("PM")
             
             if hour == 12 {
                 hourIn24HourFormat = isPM ? 12 : 0
             } else {
                 hourIn24HourFormat += isPM ? 12 : 0
             }
             
             return String(format: "%02d:%02d", hourIn24HourFormat, minute)
         }
     }


    
//    class func convertPmTo24(time: String) -> String? {
//        let timeComponents = time.components(separatedBy: ":")
//        
//        guard timeComponents.count == 2,
//              let hour = Int(timeComponents[0]),
//              let minute = Int(timeComponents[1].prefix(2)) else {
//            return nil
//        }
//        
//        var hourIn24HourFormat = hour
//        let isPM = time.contains("PM")
//        
//        if hour == 12 {
//            hourIn24HourFormat = isPM ? 12 : 0
//        } else {
//            hourIn24HourFormat += isPM ? 12 : 0
//        }
//        
//        return String(format: "%02d:%02d", hourIn24HourFormat, minute)
//    }


    
//    class func convertPmTo24 (dateAsString:String)->String?{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "h:mm a"
//
//        let timeAm = dateFormatter.date(from: dateAsString)
//
//        dateFormatter.dateFormat = "HH:mm"
//        if let timeAm = timeAm{
//            return dateFormatter.string(from: timeAm)
//        }
//        return nil
//    }
}

extension Date {
    
    func changeDateFormat(format : String) ->String{
       
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = format //Set date style
       dateFormatter.timeZone = TimeZone.current
       dateFormatter.locale = Locale.init(identifier: Locale.current.identifier)

       let localDate = dateFormatter.string(from: self)
       
       return localDate
   }
    
    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }
    
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }
    
    func isSmallerThan(_ date: Date) -> Bool {
        return self < date
    }
    
    func advanceDate(byHours hours: Int? = nil, minutes: Int? = nil, days: Int? = nil, months: Int? = nil, years: Int? = nil) -> Date? {
        
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.hour = hours
        components.minute = minutes
        components.day = days
        components.month = months
        components.year = years
                
        let advancedDate = calendar.date(byAdding: components, to: self)
        
        return advancedDate
    }
    
   
}


extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}


class GoogleAnalyticsManager {
    
    
//    class func logAPI(apiName: String? , response: String?, request: String?) {
//        
//        
//        Analytics.logEvent("PaymentApi", parameters: [
//            "name": (apiName ?? "") as String,
//            "response": (response ?? "") as String,
//            "request" : (request ?? "") as String
//        ])
//        
//        
//    }
    
    class func logScreenView(screenName: String? , screenClass: String?) {
        
        
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: screenName ?? "",
                                        AnalyticsParameterScreenClass: screenClass ?? ""])
        
        
    }
    
    
    class func logPaymentWithTransactionId(transactionId: String? , totalPrice : Double?) {
        
        let purchaseParams: [String: Any] = [
            AnalyticsParameterTransactionID: transactionId as Any,
           AnalyticsParameterAffiliation: "IOS",
            AnalyticsParameterCurrency: "SAR",
            AnalyticsParameterValue: totalPrice as Any,
        ]
        
        
        Analytics.logEvent(AnalyticsEventPurchase, parameters: purchaseParams)


    }
    
    
}

class StringUtils {
    
    class func decimal(string:String?) -> String {
         let dblValue = Double(string!)
         var string2Dec = String(format: "%.2f", dblValue!)
         let instance = NumberFormatter()
  
         if( instance.number(from: string!)?.doubleValue == nil)
         {
            string2Dec = String(format: "%.0f", dblValue!)
         }
         if(dblValue == 0.0)
         {
             string2Dec = String(format: "%.0f", dblValue!)
         }
         return string2Dec
         
     }

}
