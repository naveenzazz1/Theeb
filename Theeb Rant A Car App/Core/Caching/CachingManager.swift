//
//  CachingManager.swift
//  Theeb Rant A Car App
//
//  Created by Moustafa Gadallah on 24/04/1443 AH.
//

import Foundation

class CachingManager: NSObject {
    
   static var alforsanID: String? {
        get {
            return (UserDefaults.standard.value(forKey: CachingKeys.AlforsanID) as? String)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: CachingKeys.AlforsanID)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var notificationsTitleAndBody: [Messages]? {
         get {
             guard let notificationData = UserDefaults.standard.object(forKey: CachingKeys.NotificationsTitleAndBody) as? Data else { return nil }
                 let notificationObject = try? JSONDecoder().decode([Messages].self, from: notificationData)
                 return notificationObject
         }
         set {
             if let encoded = try? JSONEncoder().encode(newValue) {
                 UserDefaults.standard.set(encoded, forKey: CachingKeys.NotificationsTitleAndBody)
                 UserDefaults.standard.synchronize()
             }
         }
     }
    
    static var isFirstLogin: Bool? {
         get {
             return (UserDefaults.standard.value(forKey: CachingKeys.isFirstLogin) as? Bool)
         }
         set {
             UserDefaults.standard.set(newValue, forKey: CachingKeys.isFirstLogin)
             UserDefaults.standard.synchronize()
         }
     }
    
    static var isFaceIdEnabled: Bool? {
         get {
             return (UserDefaults.standard.value(forKey: CachingKeys.faceIDenabled) as? Bool)
         }
         set {
             UserDefaults.standard.set(newValue, forKey: CachingKeys.faceIDenabled)
             UserDefaults.standard.synchronize()
         }
     }
    
    class func ehsanToken() -> String? {
        
        return CachingManager.getValue(forKey: CachingKeys.EhsanToken) as? String
    }
    
    
    class func priceEstimateCDP() -> String? {
        
        return CachingManager.getValue(forKey: CachingKeys.PriceEstimateCDP) as? String
    }
    
    
    static var currentLang: String? {
         get {
             return (UserDefaults.standard.value(forKey: "currentLang") as? String)
         }
         set {
             UserDefaults.standard.set(newValue, forKey: "currentLang")
             UserDefaults.standard.synchronize()
         }
     }
    
    static var royaltyPointBal: String? {
         get {
             return (UserDefaults.standard.value(forKey: CachingKeys.RoyaltyPointBal) as? String)
         }
         set {
             UserDefaults.standard.set(newValue, forKey: CachingKeys.RoyaltyPointBal)
             UserDefaults.standard.synchronize()
         }
     }
    
    
    class func store(value: Any?, forKey key: String) {
        
        UserDefaults.standard.set(value, forKey: key)
    }
    
    class func removeValue(forKey key: String) {
        
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    class func getValue(forKey key: String) -> Any? {
        
        return UserDefaults.standard.value(forKey: key)
    }
    
    
    
    
    
    class func setLoginObject(_ loginObject: User?) {
        
        guard let loginObject = loginObject else { return }
        
        do {
            let loginObjectData = try JSONEncoder().encode(loginObject)
            UserDefaults.standard.set(loginObjectData, forKey: CachingKeys.LoggedInUserData)
            
        } catch { }
    }
    
    static var memberDriverModel: DriverProfile? {
         get {
             guard let memberData = UserDefaults.standard.object(forKey: CachingKeys.memberDriverModel) as? Data else { return nil }
                 let memberObject = try? JSONDecoder().decode(DriverProfile.self, from: memberData)
                 return memberObject
         }
         set {
             let memberData = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(memberData, forKey: CachingKeys.memberDriverModel)
             UserDefaults.standard.synchronize()
         }
     }
    
    
    class func loginObject() -> User? {
        
        guard let loginobject = UserDefaults.standard.object(forKey: CachingKeys.LoggedInUserData) as? Data else { return nil }
        
        do {
            let loginObject = try JSONDecoder().decode(User.self, from: loginobject)
            return loginObject
            
        } catch { }
        
        return nil
    }
    
    class func setLocations(_ locations: [Branch?]?) {
        
        guard let locations = locations else { return }
        
        do {
            let placesData = try JSONEncoder().encode(locations)
           UserDefaults.standard.set(placesData, forKey: CachingKeys.Locations)
            
        } catch { }
    }
    
    class func setCarModels(_ carModels: [CarGroup?]?) {
        
        guard let carModels = carModels else { return }
        
        do {
            let placesData = try JSONEncoder().encode(carModels)
           UserDefaults.standard.set(placesData, forKey: CachingKeys.CarModels)
            
        } catch { }
    }
    
    
    class func locations() -> [Branch?]? {
        
        guard let placesData = UserDefaults.standard.object(forKey: CachingKeys.Locations) as? Data else { return nil }
        
        do {
           let locations = try JSONDecoder().decode([Branch?]?.self, from: placesData)
           return locations
            
        } catch { }
        
        return nil
    }
    
    class func carModels() -> [CarGroup]? {
        
        guard let placesData = UserDefaults.standard.object(forKey: CachingKeys.CarModels) as? Data else { return nil }
        
        do {
           let locations = try JSONDecoder().decode([CarGroup]?.self, from: placesData)
           return locations
            
        } catch { }
        
        return nil
    }
    
  
    class func setVechileTypes(_ carModels: [VehicleTypeModel?]?) {
        
        guard let carModels = carModels else { return }
        
        do {
            let placesData = try JSONEncoder().encode(carModels)
           UserDefaults.standard.set(placesData, forKey: CachingKeys.VechileTypes)
            
        } catch { }
    }
    
    class func setMakeNames(_ carModels: [Brand?]?) {
        
        guard let carModels = carModels else { return }
        
        do {
            let placesData = try JSONEncoder().encode(carModels)
           UserDefaults.standard.set(placesData, forKey: CachingKeys.MakeNames)
            
        } catch { }
    }
    class func makeNames() -> [Brand?]? {
        
        guard let placesData = UserDefaults.standard.object(forKey: CachingKeys.MakeNames) as? Data else { return nil }
        
        do {
           let locations = try JSONDecoder().decode([Brand?]?.self, from: placesData)
           return locations
            
        } catch { }
        
        return nil
    }
    
    class func vechileTypes() -> [VehicleTypeModel]? {
        
        guard let placesData = UserDefaults.standard.object(forKey: CachingKeys.VechileTypes) as? Data else { return nil }
        
        do {
           let locations = try JSONDecoder().decode([VehicleTypeModel]?.self, from: placesData)
           return locations
            
        } catch { }
        
        return nil
    }
    
    
    
    
    
    class func email() -> String? {
        
        return CachingManager.getValue(forKey: CachingKeys.email) as? String
    }

//    class func password() -> String? {
//
//        return  CachingManager.getValue(forKey: CachingKeys.password) as? String
//    }
    
    static var storedPassword: String? {
         get {
             return (UserDefaults.standard.value(forKey: CachingKeys.password) as? String)
         }
         set {
             UserDefaults.standard.set(newValue, forKey: CachingKeys.password)
             UserDefaults.standard.synchronize()
         }
     }
    
    
    
    class func notifications() -> [UNNotification?]? {
         
        if let notificationsData = UserDefaults.standard.object(forKey: CachingKeys.Notifications) as? Data {
            
            let notifications = NSKeyedUnarchiver.unarchiveObject(with: notificationsData)
            return notifications as? [UNNotification?]
        }

         return nil
     }
    
    class func setNotifications(_ notifications: [UNNotification?]?) {
         
        do {
            let notificationsData = try NSKeyedArchiver.archivedData(withRootObject: notifications as Any, requiringSecureCoding: true)
            UserDefaults.standard.set(notificationsData, forKey: CachingKeys.Notifications)
            UserDefaults.standard.synchronize()
            
        } catch { }
    }
    
    
    static var storedToken: String? {
         get {
             return (UserDefaults.standard.value(forKey: CachingKeys.token) as? String)
         }
         set {
             UserDefaults.standard.set(newValue, forKey: CachingKeys.token)
             UserDefaults.standard.synchronize()
         }
     }
    
    
    
}


