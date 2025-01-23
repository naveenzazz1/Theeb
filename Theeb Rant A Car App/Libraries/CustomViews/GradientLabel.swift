//
//  GradientLabel.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 30/03/2022.
//

import UIKit

class GradientLabel: UILabel {
    
     var topColor: UIColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) {
        didSet { setNeedsLayout() }
    }
    
     var bottomColor: UIColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1) {
        didSet { setNeedsLayout() }
    }
  
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateTextColor()
    }
    
    private func updateTextColor() {
        let image = UIGraphicsImageRenderer(bounds: bounds).image { context in
            let colors = [topColor.cgColor, bottomColor.cgColor]
            guard let gradient = CGGradient(colorsSpace: nil, colors: colors as CFArray, locations: nil) else { return }
            context.cgContext.drawLinearGradient(gradient,
                                                 start: CGPoint(x: bounds.midX, y: bounds.minY),
                                                 end: CGPoint(x: bounds.midX, y: bounds.maxY),
                                                 options: [])
        }
        
        textColor = UIColor(patternImage: image)
    }
    

    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        let gredient = GradientView.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
//        gredient.bottomColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
//        gredient.topColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
//        setTextColorToGradient(image: imageWithView(view: gredient)!)
//    }

    
//    func imageWithView(view: UIView) -> UIImage? {//bet7awel uiview to image
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
//        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
//        let img = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return img
//    }
//
//    func setTextColorToGradient(image: UIImage) {//beta7'od image we tekteb beha el text fe el label
//        UIGraphicsBeginImageContext(frame.size)
//        image.draw(in: bounds)
//        let myGradient = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        textColor = UIColor(patternImage: myGradient!)
//
//    }

}

