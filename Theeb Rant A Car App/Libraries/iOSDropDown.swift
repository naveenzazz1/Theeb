
//
//  iOSDropDown.swift
//
//
//  Created by Jishnu Raj T on 26/04/18.
//  Copyright © 2018 JRiOSdev. All rights reserved.
//
import UIKit

open class DropDown : JVFloatLabeledTextField{

    var arrow : Arrow!
    var table : UITableView!
    var shadow : UIView!
    var isImage = true
    public  var selectedIndex: Int?
    public weak var parentView:UIView?

    //MARK: IBInspectable

    @IBInspectable public var rowHeight: CGFloat = 30
    @IBInspectable public var rowBackgroundColor: UIColor = .white
    @IBInspectable public var rowTextColor: UIColor = .black
    @IBInspectable public var selectedRowColor: UIColor = .cyan
    @IBInspectable public var hideOptionsWhenSelect = true
    @IBInspectable  public var isSearchEnable: Bool = true {
        didSet{
            addGesture()
        }
    }

    @IBInspectable public var listHeight: CGFloat = 150{
        didSet {

        }
    }


    //Variables
    fileprivate  var tableheightX: CGFloat = 100
    fileprivate  var dataArray = [String]()
    fileprivate  var imageArray = [String]()
    fileprivate  var parentController:UIViewController?
    fileprivate  var pointToParent = CGPoint(x: 0, y: 0)
    fileprivate var backgroundView = UIView()
    fileprivate var keyboardHeight:CGFloat = 0

    public var optionArray = [String]() {
        didSet{
            self.dataArray = self.optionArray
        }
    }
    public var optionImageArray = [String]() {
        didSet{
            self.imageArray = self.optionImageArray
        }
    }
    public var optionIds : [Int]?
    var searchText = String() {
        didSet{
            if searchText == "" {
                self.dataArray = self.optionArray
            }else{
                self.dataArray = optionArray.filter {
                    return $0.range(of: searchText, options: .caseInsensitive) != nil
                }
            }
            reSizeTable()
            selectedIndex = nil
            self.table.reloadData()
        }
    }
    @IBInspectable public var arrowSize: CGFloat = 50 {
        didSet{
            let center =  arrow.superview!.center
            arrow.frame = CGRect(x: center.x - arrowSize/2, y: center.y - arrowSize/2, width: arrowSize, height: arrowSize)
        }
    }
    @IBInspectable public var arrowColor: UIColor = .black {
        didSet{
            arrow.arrowColor = arrowColor
        }
    }
    @IBInspectable public var checkMarkEnabled: Bool = true {
        didSet{
            
        }
    }
    @IBInspectable public var handleKeyboard: Bool = true {
        didSet{
            
        }
    }
    
    public var arrowPosition: Position = .right {
        didSet{
            setupArrow()
        }
    }

    // Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.delegate = self
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupUI()
        self.delegate = self
    }


    //MARK: Closures
    public var didSelectCompletion: (String, Int ,Int) -> () = {selectedText, index , id  in }
    public var TableWillAppearCompletion: () -> () = { }
    public var TableDidAppearCompletion: () -> () = { }
    public var TableWillDisappearCompletion: () -> () = { }
    public var TableDidDisappearCompletion: () -> () = { }
    public var beginEditingCompletion: (Bool) -> () = {_ in }
    
    func setupArrow() {
        
        self.leftView = nil
        self.rightView = nil
        
        let size = self.frame.height
        let rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: size, height: size))
        
        if arrowPosition == .left {
            self.leftView = rightView
            self.leftViewMode = .always
        } else {
            self.rightView = rightView
            self.rightViewMode = .always
        }
        let arrowContainerView = UIView(frame: rightView.frame)
        
        if arrowPosition == .left {
            self.leftView?.addSubview(arrowContainerView)
        } else {
            self.rightView?.addSubview(arrowContainerView)
        }
        let center = arrowContainerView.center
        arrow = Arrow(origin: CGPoint(x: center.x - arrowSize/2,y: center.y - arrowSize/2),size: arrowSize  )
        arrowContainerView.addSubview(arrow)
    }
    
    func setupUI () {
        
        setupArrow()
        
        self.backgroundView = UIView(frame: .zero)
        self.backgroundView.backgroundColor = .clear
        addGesture()
        if isSearchEnable && handleKeyboard{
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (notification) in
                if self.isFirstResponder{
                let userInfo:NSDictionary = notification.userInfo! as NSDictionary
                    let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
                let keyboardRectangle = keyboardFrame.cgRectValue
                self.keyboardHeight = keyboardRectangle.height
                    if !self.isSelected{
                        self.showList()
                    }
                }
              
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (notification) in
                if self.isFirstResponder{
                self.keyboardHeight = 0
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    fileprivate func addGesture (){
        let gesture =  UITapGestureRecognizer(target: self, action:  #selector(touchAction))
        if isSearchEnable{
            self.rightView?.addGestureRecognizer(gesture)
        }else{
            self.addGestureRecognizer(gesture)
        }
        let gesture2 =  UITapGestureRecognizer(target: self, action:  #selector(touchAction))
        self.backgroundView.addGestureRecognizer(gesture2)
    }
    func getConvertedPoint(_ targetView: UIView, baseView: UIView?)->CGPoint{
        var pnt = targetView.frame.origin
        if nil == targetView.superview{
            return pnt
        }
        var superView = targetView.superview
        while superView != baseView{
            pnt = superView!.convert(pnt, to: superView!.superview)
            if nil == superView!.superview{
                break
            }else{
                superView = superView!.superview
            }
        }
        return superView!.convert(pnt, to: baseView)
    }
    
    
    private var containerView: UIView? {
        
        return parentView != nil ? parentView : parentController?.view
    }
    
    public func showList() {
        if parentController == nil{
            parentController = self.parentViewController
        }
        
//        backgroundView.frame = parentController?.view.frame ?? backgroundView.frame
//        pointToParent = getConvertedPoint(self, baseView: parentController?.view)
//        parentController?.view.insertSubview(backgroundView, aboveSubview: self)
        backgroundView.frame = containerView?.frame ?? backgroundView.frame
        pointToParent = getConvertedPoint(self, baseView: containerView)
        containerView?.insertSubview(backgroundView, aboveSubview: self)
        
        TableWillAppearCompletion()
        if listHeight > rowHeight * CGFloat( dataArray.count) {
            self.tableheightX = rowHeight * CGFloat(dataArray.count)
        }else{
            self.tableheightX = listHeight
        }
        table = UITableView(frame: CGRect(x: pointToParent.x ,
                                          y: pointToParent.y + self.frame.height ,
                                          width: self.frame.width,
                                          height: self.frame.height))
        shadow = UIView(frame: table.frame)
        shadow.backgroundColor = .clear

        table.dataSource = self
        table.delegate = self
        table.alpha = 0
        table.separatorStyle = .none
//        table.layer.cornerRadius = 3
        table.layer.cornerRadius = 5
        table.backgroundColor = rowBackgroundColor
        table.rowHeight = rowHeight
//        parentController?.view.addSubview(shadow)
//        parentController?.view.addSubview(table)
        containerView?.addSubview(shadow)
        containerView?.addSubview(table)

        self.isSelected = true
//        let height = (self.parentController?.view.frame.height ?? 0) - (self.pointToParent.y + self.frame.height + 5)
        let height = (containerView?.frame.height ?? 0) - (self.pointToParent.y + self.frame.height + 2)
        var y = self.pointToParent.y+self.frame.height+2
        if height < (keyboardHeight+tableheightX){
//            y = self.pointToParent.y - tableheightX
              y = self.pointToParent.y+self.frame.height+2
        }
//        UIView.animate(withDuration: 0.9,
//                       delay: 0,
//                       usingSpringWithDamping: 0.4,
//                       initialSpringVelocity: 0.1,
//                       options: .curveEaseInOut,
//                       animations: { () -> Void in

                        self.table.frame = CGRect(x: self.pointToParent.x,
                                                  y: y,
                                                  width: self.frame.width,
                                                  height: self.tableheightX)
                        self.table.alpha = 1
                        self.shadow.frame = self.table.frame
                        self.shadow.dropShadow()
                        self.arrow.position = .up
                       

//        },
//                       completion: { (finish) -> Void in
                        self.layoutIfNeeded()

//        })

    }

    public var isListShowen: Bool {
        return table?.superview != nil
    }

    public func hideList() {
        
        guard table != nil else { return }
        
        TableWillDisappearCompletion()
//        UIView.animate(withDuration: 1.0,
//                       delay: 0.4,
//                       usingSpringWithDamping: 0.9,
//                       initialSpringVelocity: 0.1,
//                       options: .curveEaseInOut,
//                       animations: { () -> Void in
                        self.table.frame = CGRect(x: self.pointToParent.x,
                                                  y: self.pointToParent.y+self.frame.height,
                                                  width: self.frame.width,
                                                  height: 0)
                        self.shadow.alpha = 0
                        self.shadow.frame = self.table.frame
                        self.arrow.position = .down
//        },
//                       completion: { (didFinish) -> Void in

                        self.shadow.removeFromSuperview()
                        self.table.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                        self.isSelected = false
                        self.TableDidDisappearCompletion()
//        })
    }

    @objc public func touchAction() {

        isSelected ?  hideList() : showList()
        beginEditingCompletion(true)

    }
    func reSizeTable() {
        if listHeight > rowHeight * CGFloat( dataArray.count) {
            self.tableheightX = rowHeight * CGFloat(dataArray.count)
        }else{
            self.tableheightX = listHeight
        }
//        let height = (self.parentController?.view.frame.height ?? 0) - (self.pointToParent.y + self.frame.height + 5)
        let height = (containerView?.frame.height ?? 0) - (self.pointToParent.y + self.frame.height + 2)
        var y = self.pointToParent.y+self.frame.height+2
        if height < (keyboardHeight+tableheightX){
//            y = self.pointToParent.y - tableheightX
              y = self.pointToParent.y+self.frame.height+2
        }
//        UIView.animate(withDuration: 0.2,
//                       delay: 0.1,
//                       usingSpringWithDamping: 0.9,
//                       initialSpringVelocity: 0.1,
//                       options: .curveEaseInOut,
//                       animations: { () -> Void in
                        self.table.frame = CGRect(x: self.pointToParent.x,
                                                  y: y,
                                                  width: self.frame.width,
                                                  height: self.tableheightX)
                        self.shadow.frame = self.table.frame
                        self.shadow.dropShadow()

//        },
//                       completion: { (didFinish) -> Void in
                      //  self.shadow.layer.shadowPath = UIBezierPath(rect: self.table.bounds).cgPath
                        self.layoutIfNeeded()

//        })
    }

    //MARK: Actions Methods
    public func didSelect(completion: @escaping (_ selectedText: String, _ index: Int , _ id:Int ) -> ()) {
        didSelectCompletion = completion
    }

    public func listWillAppear(completion: @escaping () -> ()) {
        TableWillAppearCompletion = completion
    }

    public func listDidAppear(completion: @escaping () -> ()) {
        TableDidAppearCompletion = completion
    }

    public func listWillDisappear(completion: @escaping () -> ()) {
        TableWillDisappearCompletion = completion
    }

    public func listDidDisappear(completion: @escaping () -> ()) {
        TableDidDisappearCompletion = completion
    }

}

//MARK: UITextFieldDelegate
extension DropDown : UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        superview?.endEditing(true)
        return false
    }
    public func  textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.text = ""
//        self.selectedIndex = nil
        self.dataArray = self.optionArray
        textField.setTextFieldAttributedPlaceholder("")
        touchAction()
        beginEditingCompletion(false)
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        beginEditingCompletion(false)
        return isSearchEnable
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        beginEditingCompletion(false)
        if string != "" {
            self.searchText = self.text! + string
        }else{
            let subText = self.text?.dropLast()
            self.searchText = String(subText!)
        }
        if !isSelected {
            showList()
        }
        return true;
    }

}
///MARK: UITableViewDataSource
extension DropDown: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "DropDownCell"

        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)

        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }

        if indexPath.row != selectedIndex{
            cell!.backgroundColor = rowBackgroundColor
        }else {
            cell?.backgroundColor = selectedRowColor
        }

        if self.imageArray.count > indexPath.row {
            cell!.imageView!.image = UIImage(named: imageArray[indexPath.row])
        }
        
        cell!.textLabel!.textColor = rowTextColor
        cell!.textLabel!.text = "\(dataArray[indexPath.row])"
        cell!.accessoryType = (indexPath.row == selectedIndex) && checkMarkEnabled  ? .checkmark : .none
        cell!.selectionStyle = .none
        cell?.textLabel?.font = self.font
        if isImage{
        cell?.imageView?.image = UIImage(named: "map-pin-2-line")
        }
        cell?.textLabel?.textAlignment = self.textAlignment
        return cell!
    }
}
//MARK: UITableViewDelegate
extension DropDown: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = (indexPath as NSIndexPath).row
        let selectedText = self.dataArray[self.selectedIndex!]
        tableView.cellForRow(at: indexPath)?.alpha = 0
//        UIView.animate(withDuration: 0.5,
//                       animations: { () -> Void in
                        tableView.cellForRow(at: indexPath)?.alpha = 1.0
                        tableView.cellForRow(at: indexPath)?.backgroundColor = self.selectedRowColor
//        } ,
//                       completion: { (didFinish) -> Void in
                        self.text = "\(selectedText)"

                        tableView.reloadData()
//        })
        if hideOptionsWhenSelect {
            touchAction()
            self.endEditing(true)
        }
        if let selected = optionArray.firstIndex(where: {$0 == selectedText}) {
            if let id = optionIds?[selected] {
                didSelectCompletion(selectedText, selected , id )
            }else{
                didSelectCompletion(selectedText, selected , 0)
            }

        }

    }
}






//MARK: Arrow
public enum Position {
    case left
    case down
    case right
    case up
}

class Arrow: UIView {
    var image = UIImage(named: "dropdown_green")
    let shapeLayer = CAShapeLayer()
    var arrowColor:UIColor = .black {
        didSet{
            shapeLayer.fillColor = arrowColor.cgColor
        }
    }
    
    var position: Position = .down {
        didSet{
            switch position {
            case .left:
                self.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
                break

            case .down:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi*2)
                break

            case .right:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                break

            case .up:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                break
            }
        }
    }

    init(origin: CGPoint, size: CGFloat ) {
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: size, height: size))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {

        let imView = UIImageView(image: image)
        sizeToFit()
        self.addSubview(imView)
        
        // Get size
        let size = self.layer.frame.width

        // Create path
        let bezierPath = UIBezierPath()

        // Draw points
        let qSize = size/4

        bezierPath.move(to: CGPoint(x: 0, y: qSize))
        bezierPath.addLine(to: CGPoint(x: size, y: qSize))
        bezierPath.addLine(to: CGPoint(x: size/2, y: qSize*3))
        bezierPath.addLine(to: CGPoint(x: 0, y: qSize))
        //bezierPath.close()

        // Mask to path
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.strokeColor = arrowColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor

        shapeLayer.isHidden = true
        
        if #available(iOS 12.0, *) {
            self.layer.addSublayer (shapeLayer)
        } else {
            self.layer.mask = shapeLayer
        }
    }
}

extension UIView {

    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

