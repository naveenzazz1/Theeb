//
//  UIColor+CustomColors.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 08/06/1443 AH.
//

import UIKit

extension UIColor {
    
    public convenience init(hex: UInt32) {
        let value = hex & 0xffffff
        let red = (CGFloat)((value >> 16) & 0xff)/255.0
        let green = (CGFloat)((value >> 8) & 0xff)/255.0
        let blue = (CGFloat)(value & 0xff)/255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIColor {
    
    public static var darkBlueColor: UIColor {
        
        return UIColor(hex: 0x162E6B)
    }
    
    public static var redValidationColor: UIColor {
        
        return UIColor(hex: 0xE02020)
    }

  public static var WeemredValidationColor: UIColor {
         
         return UIColor(hexString: "#FC440F" )
    
    }
    
    public static var WeemBoredersColor: UIColor {
            
            return UIColor(hexString: "#C9CED6" )
       
    }
    
    public static var WeemLightGrayColor: UIColor {
            
            return UIColor(hexString: "#26E989" )
       
       }
   
    
    public static var menuItemColor: UIColor {
        
        return UIColor.weemBlack
    }
    
    
    public static var logoutItemColor: UIColor {
        
        return UIColor.red
    }
   
   
    
    public static var lightGreenColor: UIColor {
        
        return UIColor(red: 108.0/255.0, green: 241.0/255.0, blue: 194.0/255.0, alpha: 1.0)
    }
    
    public static var filterItemSelectedBackgroundColor: UIColor {
        
        return UIColor(white: 51.0/255.0, alpha: 1.0)
    }
    
    public static var filterItemUnSelectedBackgroundColor: UIColor {
        
        return UIColor(white: 228.0/255.0, alpha: 1.0)
    }
    
    public static var weemBlack: UIColor {
        
        return UIColor(hex: 0x222B45)
    }
    
    public static var weemBlue: UIColor {
        
        return UIColor(hex: 0x10069F)
    }
    
    public static var weemGreen: UIColor {
        
        return UIColor(hex: 0x26E989)
    }
    
    public static var weemGrayBorder: UIColor {
        
        return UIColor(hex: 0xC9CED6)
    }
    
    public static var weemGrayNavigationBarColor: UIColor {
        
        return UIColor(hex: 0xEFEFEF)
    }
    
    public static var weemLightGray: UIColor {
        
        return UIColor(hex: 0xF5F5F5)
    }
    
    public static var weemDarkGray: UIColor {
        
        return UIColor(hex: 0xC9CED6)
    }
    
    public static var theebColor: UIColor {
        
        return UIColor(hex: 0x2E6A9F)
    }
    
    public static var theebPrimaryColor: UIColor {
        
        return UIColor(hex: 0x3E78A8)
    }
    public static var theebSecondaryColor: UIColor {
       
        return UIColor(hex: 0x3E78A8)
    }
    
}

extension UIColor {
    
    func isDarkColor() -> Bool {
        
        var white: CGFloat = 0
        self.getWhite(&white, alpha: nil)
        return white < 0.9
    }
}



