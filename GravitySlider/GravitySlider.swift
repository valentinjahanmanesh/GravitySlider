//
//  GravitySlider.swift
//  GravitySlider
//
//  Created by Farshad.Jahanmanesh on 9.08.2018.
//  Copyright © 2018 Farshad.Jahanmanesh. All rights reserved.
//

import UIKit

@IBDesignable
class GravitySlider : UIView {
    
    ///prepare for innterface builder
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    ///get center of view
    var myCenter : CGPoint {
        get {
            return CGPoint(x: useableFrame.width / 2, y: useableFrame.height / 2)
        }
    }
    
    /// the circle view that user grab and move
    private var circleIndicatorView: UIView! {
        willSet {
            newValue.layer.cornerRadius = newValue.frame.width/2.0
            newValue.layer.backgroundColor = UIColor.black.cgColor
        }
    }
    
    ///this closure will call everytime value changes
    var valueChangeCallback : ((Int)->Void)?
    
    /// keep reference of line layer
    private var lineLayer : CAShapeLayer!
    /// keep reference of rounded triangle layer
    private var triangleLayer : CAShapeLayer!
    /// keep reference of value layer
    private var numberLayer : CATextLayer!
    /// keep reference of highlighter layer
    private var highlighterLayer : CAShapeLayer!
    /// keep reference of line layer
    private var triangleCenterY : CGFloat =  0
    private var zero : CGFloat {
        get {
            return self.useableFrame.height / 2
        }
    }
    /// Settings Object
    struct Settings {
        /// value text font
        var textFont : UIFont = UIFont.boldSystemFont(ofSize: 20)
        ///indicates how much our circle should push the line up
        var circleGravity : CGFloat = 50
        
        ///minimum and maximum values
        var values : Values = Values()
        
        ///our colors
        var colors : Colors = Colors()
        
        ///the tickness of lines
        var strokes = Strokes()
        
        /// size of our circle
        var circleRadius : CGFloat = 20
        
        ///space between line and text
        var spaceBetweenLineAndTextContianerCenter : CGFloat =  20
        struct Values {
            var minValue : Int = 0
            var maxValue : Int = 200
            var showMinValue : Bool = false
            var showMaxValue : Bool = false
        }
        struct Strokes {
            var line : CGFloat = 10
            var textContainer : CGFloat = 5
        }
        struct Colors {
            var circle : UIColor = .black
            var line : UIColor = .black
            var text : UIColor = .black
            var textContainer : UIColor = .black
            var textContainerhighlighter : UIColor = .clear
        }
    }
    ///we need a rectangle, we create our rect in our superview, because of differences of sizes and insets...
    var useableFrame : CGRect = .zero
    
    ///setting object, each time settings change, we redraw our view
    var settings : Settings = Settings() {
        didSet{
            setup()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //find the correct size of the view
        useableFrame = self.frame
        setup()
    }
    func setup(){
        //clean our view
        self.subviews.forEach({ (v) in
            v.removeFromSuperview()
        })
        //create circle view
        circleIndicatorView = UIView(frame: CGRect(x: 0, y: 0, width: (settings.circleRadius), height:(settings.circleRadius)))
        circleIndicatorView.backgroundColor = settings.colors.circle
        circleIndicatorView.center = CGPoint(x: myCenter.x, y: myCenter.y + ( settings.circleGravity))
        //self.layer.masksToBounds = true
        //clean layer
        self.layer.sublayers?.removeAll()
        
        let (triangleL,highlighterL,textL) = addRecangle()
        triangleLayer = triangleL
        highlighterLayer = highlighterL
        numberLayer = textL
        lineLayer = drawLine()
        //add line
        self.layer.addSublayer(lineLayer)
        //add circle
        self.addSubview(circleIndicatorView)
        //add textContainer Layer
        self.layer.addSublayer(triangleLayer)
        //add number Layer
        self.triangleLayer.addSublayer(numberLayer)
        //add highlitherLayer
        self.layer.addSublayer(highlighterLayer)
        
        
        //add gestures
        let longPressRecognizer = UILongPressGestureRecognizer(target: self,action: #selector(longPressed(_:)))
        longPressRecognizer.minimumPressDuration = 0.01
        circleIndicatorView.addGestureRecognizer(longPressRecognizer)
    }
    
    private func drawLine()->CAShapeLayer{
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: zero))
        bezierPath.addLine(to: CGPoint(x: (self.useableFrame.width - settings.circleGravity) / 2, y: zero))
        bezierPath.addCurve(to: CGPoint(x: (self.useableFrame.width+settings.circleGravity) / 2  , y: zero), controlPoint1: CGPoint(x: (self.useableFrame.width) / 2, y: zero), controlPoint2: CGPoint(x: (self.useableFrame.width) / 2, y: zero))
        bezierPath.addLine(to: CGPoint(x: self.useableFrame.width, y: zero))
        bezierPath.lineCapStyle = .round
        let  lineLayer = CAShapeLayer()
        lineLayer.strokeColor = UIColor.black.cgColor
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.lineWidth = 5
        lineLayer.path = bezierPath.cgPath
        lineLayer.lineCap = "round"
        return lineLayer
    }
    @objc func longPressed(_ sender: UILongPressGestureRecognizer)
    {
        guard let senderView = sender.view else {
            return
        }
        if sender.state == .ended {
            createAnimation(senderView.center.x,left: nil,toLine: true)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: .curveLinear, animations: {
                senderView.center = CGPoint(x: senderView.center.x, y: self.myCenter.y + ( self.settings.circleGravity))
                self.triangleLayer.position = CGPoint(x: self.circleIndicatorView.center.x, y: self.triangleCenterY)
                self.highlighterLayer.position = self.triangleLayer.position
            }, completion: nil)
        }
        else if sender.state == .began {
            createAnimation(senderView.center.x,left: nil)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: .curveLinear, animations: {
                senderView.center = CGPoint(x: senderView.center.x, y: self.myCenter.y + (self.settings.circleGravity/2))
                self.triangleLayer.position = CGPoint(x: self.circleIndicatorView.center.x, y: self.triangleCenterY - 20)
                self.highlighterLayer.position = self.triangleLayer.position
            }, completion: nil)
        }
        if sender.state == .changed {
            let translation = sender.location(in: self)
            if senderView.center.x > translation.x {
                if senderView.frame.origin.x <= 0 {
                    displayValue(currentX: 0)
                    return
                }
                createAnimation(senderView.center.x,left: true)
                highlighterLayer.strokeEnd =  (senderView.center.x - 20) / (self.useableFrame.width)
                
            }
            if senderView.center.x < translation.x {
                if senderView.frame.origin.x >= (self.useableFrame.width - self.settings.circleRadius) {
                    displayValue(currentX: self.useableFrame.width)
                    return
                }
                createAnimation(senderView.center.x,left: false)
                highlighterLayer.strokeEnd =  senderView.center.x / (self.useableFrame.width - 20)
            }
            print(translation.x)
            var x = translation.x
            if x < 0 {
                x = 0
            }
            if x > self.useableFrame.width {
                x = self.useableFrame.width
            }
            senderView.center = CGPoint(x: x, y: myCenter.y + (settings.circleGravity/2))
            CATransaction.setValue(kCFBooleanTrue, forKey:kCATransactionDisableActions)
            self.triangleLayer.position = CGPoint(x: self.circleIndicatorView.center.x, y: self.triangleCenterY - 20)
            self.highlighterLayer.position = self.triangleLayer.position
            //self.numberLayer.position = CGPoint(x: self.circleIndicatorView.center.x, y: self.triangleCenterY - 30)
            CATransaction.commit()
            displayValue(currentX: senderView.center.x)
            valueChangeCallback?(Int(senderView.center.x))
        }
        
        
    }
    @discardableResult
    private func displayValue(currentX: CGFloat) -> Int{
        if self.useableFrame.width == 0 {
            return 0
        }
        let value = Int((currentX * CGFloat(self.settings.values.maxValue)) /  self.useableFrame.width)
        numberLayer?.string = "\(value)"
        return value
    }
    private  func createAnimation(_ inputValue : CGFloat,left: Bool? = nil,toLine : Bool = false){
        var value = inputValue
        if value <= 0 {
            value = 0
        }
        if value >= useableFrame.width {
            value = useableFrame.width
        }
        let newPath = UIBezierPath()
        let height = toLine ? zero : zero - settings.circleGravity / 2
        let leftGravity : CGFloat = left != nil && left! ? 20 : 0
        let rightGravity : CGFloat = left != nil && !left! ? 20 : 0
        let leftLineX = (value - settings.circleGravity)
        let rightLineX = (value + settings.circleGravity)
        newPath.move(to: CGPoint(x: 0, y: zero))
        newPath.addLine(to: CGPoint(x: leftLineX > 0 ? leftLineX : 0, y: zero))
        newPath.addCurve(to: CGPoint(x: rightLineX < useableFrame.width ? rightLineX : useableFrame.width  , y: zero), controlPoint1: CGPoint(x: (value - leftGravity), y: height), controlPoint2: CGPoint(x: (value + rightGravity), y: height))
        newPath.addLine(to: CGPoint(x: self.useableFrame.width, y: zero))
        newPath.lineCapStyle = .round
        
        let anim =  CABasicAnimation(keyPath: "path")
        anim.toValue = newPath.cgPath
        anim.duration = 0.2
        anim.isRemovedOnCompletion = false;
        anim.fillMode = kCAFillModeForwards
        lineLayer.add(anim, forKey: nil)
        lineLayer.lineCap = "round"
        let spr = CASpringAnimation(keyPath: "path")
        spr.toValue = newPath.cgPath
        spr.duration = 2
        spr.isRemovedOnCompletion = false;
        spr.fillMode = kCAFillModeForwards
        spr.damping = 1
        spr.initialVelocity = 1
        // shapeLayer.add(spr, forKey: nil)
        
    }
    
    private func createRoundedTriangle(width: CGFloat, height: CGFloat, radius: CGFloat) -> CGPath {
        // Points of the triangle
        let point1 = CGPoint(x: -width / 2, y: -height / 2)
        let point2 = CGPoint(x: 0, y: height / 2)
        let point3 = CGPoint(x: width / 2, y: -height / 2)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: -height / 2))
        path.addArc(tangent1End: point1, tangent2End: point2, radius: radius)
        path.addArc(tangent1End: point2, tangent2End: point3, radius: radius/10)
        path.addArc(tangent1End: point3, tangent2End: point1, radius: radius)
        path.closeSubpath()
        
        return path
    }
    private func addRecangle()->(CAShapeLayer,CAShapeLayer,CATextLayer){
        let triangleLayer = CAShapeLayer()
        let triangleSize = (self.myCenter.y) - (settings.circleGravity + settings.circleRadius)
        triangleLayer.path = createRoundedTriangle(width: triangleSize , height: triangleSize, radius: triangleSize / 3.4)
        triangleCenterY = myCenter.y - (settings.spaceBetweenLineAndTextContianerCenter + triangleSize / 2)
        triangleLayer.position = CGPoint(x: circleIndicatorView.center.x, y: triangleCenterY)
        triangleLayer.strokeColor = settings.colors.textContainer.cgColor
        triangleLayer.fillColor = UIColor.clear.cgColor
        triangleLayer.lineWidth = settings.strokes.textContainer
        triangleLayer.contentsScale = UIScreen.main.scale
        
        let highlighterLayer = CAShapeLayer()
        highlighterLayer.path = createRoundedTriangle(width: triangleSize , height: triangleSize, radius: triangleSize / 3.4)
        highlighterLayer.position = triangleLayer.position
        highlighterLayer.strokeColor = settings.colors.textContainerhighlighter.cgColor
        highlighterLayer.fillColor = UIColor.clear.cgColor
        highlighterLayer.lineWidth = settings.strokes.textContainer
        highlighterLayer.strokeEnd = 0.5
        highlighterLayer.contentsScale = UIScreen.main.scale
        //highlighterLayer.fillColor = UIColor.red.cgColor
        
        let numberLayer = CATextLayer()
        numberLayer.contentsScale = UIScreen.main.scale
        numberLayer.font = settings.textFont
        numberLayer.fontSize = settings.textFont.pointSize
        numberLayer.frame = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: triangleSize - 4, height: textHeight(string: "\(Int(self.useableFrame.width / 2))", withConstrainedWidth: triangleSize - 4, font: settings.textFont)))
        numberLayer.position = CGPoint(x: 0, y: -numberLayer.frame.height/1.4)
        numberLayer.string = "\(displayValue(currentX: self.useableFrame.width / 2))"
        numberLayer.foregroundColor = settings.colors.text.cgColor
        numberLayer.masksToBounds = false
        numberLayer.isHidden = false
        numberLayer.alignmentMode = kCAAlignmentCenter
        
        return (triangleLayer,highlighterLayer,numberLayer)
        
    }
    private func textHeight(string:String,withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat{
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

