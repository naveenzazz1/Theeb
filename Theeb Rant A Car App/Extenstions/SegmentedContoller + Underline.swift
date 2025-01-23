//
//  SegmentedContoller + Underline.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 26/04/1443 AH.
//

import UIKit

import UIKit

extension UISegmentedControl {
    func removeBorder(){
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)

        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 67/255, green: 129/255, blue: 244/255, alpha: 1.0)], for: .selected)
    }

    func addUnderlineForSelectedSegment(){
        removeBorder()
        
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 2.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 1.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor(red: 67/255, green: 129/255, blue: 244/255, alpha: 1.0)
        underline.tag = 1
        self.addSubview(underline)
    }

    func changeUnderlinePosition() {
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
    
    
}

extension UIImage {

   
    
    func flipHorizontally() -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
            let context = UIGraphicsGetCurrentContext()!
            
            context.translateBy(x: self.size.width/2, y: self.size.height/2)
            context.scaleBy(x: -1.0, y: 1.0)
            context.translateBy(x: -self.size.width/2, y: -self.size.height/2)
            
            self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
        return newImage?.withRenderingMode(.alwaysTemplate)
        }
    
    func imageLocalized()->UIImage{
        let img = UIApplication.isRTL() ? self.imageFlippedForRightToLeftLayoutDirection():self
        return img
    }
    
    func serializeImageToString()->String?{
        let imgData = UIImage.jpegData(self)(compressionQuality: 0.4)
        let imgStr = imgData?.base64EncodedString(options: .lineLength64Characters)
        return imgStr
    }
    
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
}

extension UIImageView{
    func setImageFromBase64(base64String:String?){
        if let base64String = base64String,let dataImage =  Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) {
            
            self.image = UIImage(data:dataImage )
        }
    }
}

extension UIViewController{
    func presentDetail(_ viewControl : UIViewController,_ direction:CATransitionSubtype = .fromRight){
        let transtion = CATransition()
        transtion.duration = 0.3
        transtion.type = CATransitionType.push
        transtion.subtype = direction  //hato men el yemen
        self.view.window?.layer.add(transtion, forKey: kCATransition)    //hane3mel add lel transion
        viewControl.modalPresentationStyle = .fullScreen
        present(viewControl, animated: false, completion: nil)
    }
    
    func dissmissToVc(_ viewControl : UIViewController){
        let transtion = CATransition() //CA 2e7'tesar Core Animation ..lazem ne3mel create lel transtion
        transtion.duration = 0.3
        transtion.type = CATransitionType.reveal
        transtion.subtype = CATransitionSubtype.fromRight  //hato men el yemen
        self.view.window?.layer.add(transtion, forKey: kCATransition)    //hane3mel add lel transion
        viewControl.modalPresentationStyle = .fullScreen
        present(viewControl, animated: false, completion: nil)
    }
    
    func dissmissDetail (_ direction:CATransitionSubtype = .fromLeft){
        let transtion = CATransition() //CA 2e7'tesar Core Animation ..lazem ne3mel create lel transtion
        transtion.duration = 0.3
        transtion.type = CATransitionType.push
        transtion.subtype = direction  //hato men el yemen
        self.view.window?.layer.add(transtion, forKey: kCATransition)    //hane3mel add lel transion
        dismiss(animated: false, completion: nil)
    }
    
}

extension Date {
    func localizedDescription() -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
    
}
