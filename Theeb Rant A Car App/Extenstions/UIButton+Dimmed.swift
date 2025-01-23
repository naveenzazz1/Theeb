//
//  UIButton+Dimmed.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 12/07/1443 AH.
//


import UIKit

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}


extension UIControl {
    
    @IBInspectable
    var dimmed: Bool {
        
        set {
            isEnabled = !newValue
            alpha = newValue ? AlphaStyles.disabled : AlphaStyles.enabled
        }
        get {
            return !isEnabled
        }
    }

}

extension UIStackView{
    
    func removeInputView(view: UIView) {
        removeArrangedSubview(view)
        view.isHidden = true
    }
    
    func addInputView(view: UIView, atIndex index: Int) {
        insertArrangedSubview(view, at: index)
        view.isHidden = false
    }
}



extension UISegmentedControl {
    
    /// Tint color doesn't have any effect on iOS 13.
    func ensureiOS12Style() {
        if #available(iOS 13, *) {
            
            let tintColorImage = UIImage(color: tintColor)
            let dividerImage = UIImage(color: tintColor, size: CGSize(width: 0.3, height: 1.0))
            // Must set the background image for normal to something (even clear) else the rest won't work
            setBackgroundImage(UIImage(color: backgroundColor ?? .clear), for: .normal, barMetrics: .default)
            setBackgroundImage(tintColorImage, for: .selected, barMetrics: .default)
            setBackgroundImage(UIImage(color: tintColor.withAlphaComponent(0.2)), for: .highlighted, barMetrics: .default)
            setBackgroundImage(tintColorImage, for: [.highlighted, .selected], barMetrics: .default)
            setTitleTextAttributes([.foregroundColor: tintColor ?? .clear, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)], for: .normal)
            setDividerImage(dividerImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            layer.borderWidth = 1
            layer.borderColor = tintColor.cgColor
            layer.cornerRadius = 0.2
            
            layer.maskedCorners = .init()
        }
    }
    
    func defaultConfiguration() {
        
        ensureiOS12Style()

        let selectedStateColor = UIColor.weemBlue
        let normalStateColor = UIColor.white

        let systemFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        let montserratBoldFont = UIFont.montserratBold(fontSize: 17)
        
        let titleTextAttributes: [NSAttributedString.Key : Any]? = [
            NSAttributedString.Key.foregroundColor: selectedStateColor,
            NSAttributedString.Key.font : montserratBoldFont ?? systemFont
        ]
        
        let selectedtitleTextAttributes: [NSAttributedString.Key : Any]? = [
            NSAttributedString.Key.foregroundColor: normalStateColor,
            NSAttributedString.Key.font : montserratBoldFont ?? systemFont
        ]
        
        setTitleTextAttributes(titleTextAttributes, for: .normal)
        setTitleTextAttributes(selectedtitleTextAttributes, for: .selected)
    }
}



extension Decodable {
    
    init?(from response: Any?) {
        
        do {
            guard let response = response else { return nil }
            
            let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            self = try JSONDecoder().decode(Self.self, from: data)
            
        } catch {
            
            return nil
        }
    }
}
