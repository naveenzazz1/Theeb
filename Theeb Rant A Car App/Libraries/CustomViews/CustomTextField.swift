//
//  CustomTextField.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 13/03/2022.
//

import UIKit

class CustomTextField: UITextField {
  
    var complition:((_ btn:UIButton)->())?
    var borderColorVal = UIColor.darkGray.cgColor{
        didSet{
            layer.borderColor = borderColorVal
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        layer.borderWidth = 0.2
        layer.borderColor = borderColorVal
    }
        let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        override open func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        
        }
        
        override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
           //return UIEdgeInsetsInsetRect(bounds, padding)
            return bounds.inset(by: padding)

        }
        
        override open func editingRect(forBounds bounds: CGRect) -> CGRect {
            //return UIEdgeInsetsInsetRect(bounds, padding)
            return bounds.inset(by: padding)

        }
    
    func addBtn(tagBtn:Int,complition:((_ btn:UIButton)->())?){
        self.complition = complition
        let button = UIButton(type: .custom)
       // button.setImage(UIImage(named: "dropdown_green"), for: .normal)
        button.setTitle("profile_updateBtn".localized, for: .normal)
        button.setTitleColor(UIColor.theebPrimaryColor, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.tag = tagBtn
        button.frame = CGRect(x: CGFloat(frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action:#selector(btnPressed(_:)) , for: .touchUpInside)
        rightView = button
        rightViewMode = .always
    }

    @objc func btnPressed(_ btn:UIButton){
        complition?(btn)
    }
}


extension UIView {

    func flash() {
        // Take as snapshot of the button and render as a template
        let snapshot = self.snapshot?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: snapshot)
        // Add it image view and render close to white
        imageView.tintColor = UIColor.init(hex: 0x5C9AC1)
        guard let image = imageView.snapshot  else { return }
        let width = image.size.width
        let height = image.size.height
        // Create CALayer and add light content to it
        let shineLayer = CALayer()
        shineLayer.contents = image.cgImage
        shineLayer.frame = bounds

        // create CAGradientLayer that will act as mask clear = not shown, opaque = rendered
        // Adjust gradient to increase width and angle of highlight
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor,
                                UIColor.clear.cgColor,
                                UIColor.black.cgColor,
                                UIColor.clear.cgColor,
                                UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 0.35, 0.50, 0.65, 0.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)

        gradientLayer.frame = CGRect(x: -width, y: 0, width: width, height: height)
        // Create CA animation that will move mask from outside bounds left to outside bounds right
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.byValue = width * 2
        // How long it takes for glare to move across button
        animation.duration = 3
        animation.speed = 3.0
        // Repeat forever
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        layer.addSublayer(shineLayer)
        shineLayer.mask = gradientLayer

        // Add animation
        gradientLayer.add(animation, forKey: "shine")
    }

    func stopFlash() {
        // Search all sublayer masks for "shine" animation and remove
        layer.sublayers?.forEach {
            $0.mask?.removeAnimation(forKey: "shine")
        }
    }
}

extension UIView {
    // Helper to snapshot a view
    var snapshot: UIImage? {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)

        let image = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        return image
    }
}
