//
//  String+Localization.swift
//  Theeb Rant A Car App
//
//  Created by Moustafa Gadallah on 24/04/1443 AH.
//

import UIKit
extension String {
    
    var localized: String {
        
        return NSLocalizedString(self, comment: self)
    }
    
    func localized(fromTable tableName: String) -> String {
    
        return NSLocalizedString(self, tableName: tableName, bundle: Bundle.main, value: self, comment: self)
    }
    
    func imageToText(img:UIImage?)->NSMutableAttributedString{
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.headIndent = 12
      let mainString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
      let imageAttachment = NSTextAttachment()
        let imgToFit = img?.resize(targetSize: CGSize(width: 14, height: 14))
      let titleFont = UIFont.montserratSemiBold(fontSize: 15)
        imageAttachment.bounds = CGRect(x: 0, y: 4+((titleFont?.capHeight ?? 13 - (imgToFit?.size.height ?? 20)).rounded()) / -1.2, width: imgToFit?.size.width ?? 20, height: imgToFit?.size.height ?? 20)
      imageAttachment.image = imgToFit

      let imageString = NSAttributedString(attachment: imageAttachment)
      mainString.append(imageString)
      //mainString.append(NSAttributedString(string: "End"))
      return mainString
    }
    
    
}

extension Formatter {
    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "em_US_POSIX")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}


extension UIView {
    
    func makeCircular() {
        
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.clipsToBounds = true
    }
    
}


protocol AttributedStringComponent {
    var text: String { get }
    func getAttributes() -> [NSAttributedString.Key: Any]?
}

// MARK: String extensions

extension String: AttributedStringComponent {
    var text: String { self }
    func getAttributes() -> [NSAttributedString.Key: Any]? { return nil }
}

extension String {
    func toAttributed(with attributes: [NSAttributedString.Key: Any]?) -> NSAttributedString {
        .init(string: self, attributes: attributes)
    }
    
    var toFormattedString: String?{
        let formatter = NumberFormatter()
     //   formatter.locale = Locale.current // Locale(identifier: "de")
    //    formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 3
        return formatter.string(from: Double(self ) as? NSNumber ?? 0)
    }
}

// MARK: NSAttributedString extensions

extension NSAttributedString: AttributedStringComponent {
    var text: String { string }

    func getAttributes() -> [Key: Any]? {
        if string.isEmpty { return nil }
        var range = NSRange(location: 0, length: string.count)
        return attributes(at: 0, effectiveRange: &range)
    }
}

extension NSAttributedString {

    convenience init?(from attributedStringComponents: [AttributedStringComponent],
                      defaultAttributes: [NSAttributedString.Key: Any],
                      joinedSeparator: String = " ") {
        switch attributedStringComponents.count {
        case 0: return nil
        default:
            var joinedString = ""
            typealias SttributedStringComponentDescriptor = ([NSAttributedString.Key: Any], NSRange)
            let sttributedStringComponents = attributedStringComponents.enumerated().flatMap { (index, component) -> [SttributedStringComponentDescriptor] in
                var components = [SttributedStringComponentDescriptor]()
                if index != 0 {
                    components.append((defaultAttributes,
                                       NSRange(location: joinedString.count, length: joinedSeparator.count)))
                    joinedString += joinedSeparator
                }
                components.append((component.getAttributes() ?? defaultAttributes,
                                   NSRange(location: joinedString.count, length: component.text.count)))
                joinedString += component.text
                return components
            }

            let attributedString = NSMutableAttributedString(string: joinedString)
            sttributedStringComponents.forEach { attributedString.addAttributes($0, range: $1) }
            self.init(attributedString: attributedString)
        }
    }
}

extension Double {
    var toFormattedString: String?{
        let formatter = NumberFormatter()
      //  formatter.locale = Locale.current // Locale(identifier: "de")
      //  formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 3
        return formatter.string(from: self as NSNumber)
    }
}
