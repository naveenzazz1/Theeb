//
//  UIView + Borders.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 26/04/1443 AH.
//

import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func scaleAnimate()
    {
        transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        alpha = 0.0
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func showToast(message: String,isNormal:Bool = true ,font: UIFont =  UIFont.cairoRegular(fontSize: 14) ?? UIFont.systemFont(ofSize: 12))->UIView {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.theebPrimaryColor
        toastLabel.textColor = .white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 2
        //toastLabel.minimumScaleFactor = 8
        
        let maxWidthPercentage: CGFloat = 1.6
        let maxTitleSize = CGSize(width: bounds.size.width , height: bounds.size.height * maxWidthPercentage)
        var titleSize = toastLabel.sizeThatFits(maxTitleSize)
        titleSize.width += 20
        titleSize.height += 10
        let yPoint:CGFloat = isNormal ? (frame.size.height + 36):(frame.size.height/3)
        toastLabel.frame = CGRect(x: frame.size.width / 2 - titleSize.width / 2, y: yPoint, width: titleSize.width, height: titleSize.height)
        
        addSubview(toastLabel)
      toastLabel.removeViewWithAnimation(duration: 1, delay: 3.5)
      return toastLabel
      }
    
    func removeViewWithAnimation(duration:Double,delay:Double){
      
      UIView.animate(withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
        self.alpha = 0.0
      }, completion: { _ in
        self.removeFromSuperview()
      })
    }
    
    
    func loadXibView(with xibFrame: CGRect) -> UIView {
        let className = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: className, bundle: bundle)
        guard let xibView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            return UIView()
        }
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        xibView.frame = xibFrame
        return xibView
    }
    
    public func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
    
    @discardableResult
    func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            let btmConst = bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant)
            btmConst.identifier = "btmConst"
            anchors.append(btmConst)
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true}) //gamed ya ebny
        
        return anchors
    }
    
}

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
