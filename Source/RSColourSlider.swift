//
//  RSColourSlider.swift
//  RSColourSlider
//
//  Created by Ramil Salimov on 18.04.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import UIKit

@objc public protocol RSColourSliderDelegate {
    @objc optional func colourValuesChanged(to hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
    @objc optional func colourValuesChanged(to red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    @objc optional func colourGotten(colour: UIColor)
}

open class RSColourSlider: UIView, UIGestureRecognizerDelegate {
    
    private var brightnessView: UIView!
    private var saturationView: UIView!

    private var gradientLayer: CAGradientLayer!
    
    public var backgroundColouredView: UIView!
    public var thumbView: UIView!
    public var colourChosen: UIColor = UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 1)
    
    public var delegate: RSColourSliderDelegate?
    
    open var brightness: CGFloat = 1.0{
        willSet{
            self.brightnessView.alpha = 1 - newValue
            self.colourChosen = UIColor(hue: thumbView.layer.position.x / self.backgroundColouredView.bounds.width, saturation: saturation, brightness: newValue, alpha: alpha)
            self.thumbView.backgroundColor = colourChosen
        }
    }
    open var saturation: CGFloat = 1.0{
        willSet{
            self.saturationView.alpha = 1 - newValue
            self.colourChosen = UIColor(hue: thumbView.layer.position.x / self.backgroundColouredView.bounds.width, saturation: newValue, brightness: brightness, alpha: alpha)
            self.thumbView.backgroundColor = colourChosen
        }
    }
    open var alphaColourValue: CGFloat = 1.0{
        willSet{
            self.backgroundColouredView.alpha = newValue
            self.colourChosen = UIColor(hue: thumbView.layer.position.x / self.backgroundColouredView.bounds.width, saturation: saturation, brightness: brightness, alpha: newValue)
            self.thumbView.backgroundColor = colourChosen
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        awakeAllParts()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColouredView.frame = self.bounds
        self.brightnessView.frame = self.bounds
        self.saturationView.frame = self.bounds
        self.gradientLayer.frame = self.bounds
        self.setSliderValueBy(colour: colourChosen)
    }
    //BUILDING
    
    private func awakeAllParts(){
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.clipsToBounds = false
        manageColouredBackgroundView()
        manageGradient()
        manageSaturationView()
        manageBrightnessView()
        addThumbView()
    }
    
    private func manageGradient(){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.backgroundColouredView.bounds.size.width, height: self.backgroundColouredView.bounds.size.height)
        
        var colours: [CGColor] = []
        var locations: [NSNumber] = []
        
        for index in 0...359{
             locations.append(NSNumber(value: (Double(index) / 359.0)))
             colours.append(UIColor(hue: CGFloat(index) / 359.0 , saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor)
        }
        gradientLayer.colors = colours
        gradientLayer.locations = locations
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        backgroundColouredView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    private func manageColouredBackgroundView(){
        backgroundColouredView = UIView(frame: self.bounds)
        backgroundColouredView.backgroundColor = .clear
        self.addSubview(backgroundColouredView)
    }
    
    private func manageSaturationView(){
        saturationView = UIView(frame: self.bounds)
        saturationView.backgroundColor = .white
        saturationView.alpha = 0
        backgroundColouredView.addSubview(saturationView)
    }
    
    private func addThumbView(){
        let widthAndHeight: CGFloat = self.bounds.height < 50 ? self.bounds.height - 10 : 40
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        thumbView = UIView(frame: CGRect(x: 0, y: 0, width: widthAndHeight, height: widthAndHeight))
        thumbView.isUserInteractionEnabled = true
        thumbView.layer.cornerRadius = widthAndHeight / 2
        thumbView.backgroundColor = UIColor(hue: thumbView.bounds.midX / self.bounds.width, saturation: saturation, brightness: brightness, alpha: alpha)
        thumbView.layer.position = CGPoint(x: 0, y: self.bounds.midY)
        //shadow
        thumbView.layer.shadowColor = UIColor.black.cgColor
        thumbView.layer.shadowOffset = .zero
        thumbView.layer.shadowOpacity = 0.3
        thumbView.layer.shadowRadius = 4.0
        //borderWidth
        thumbView.layer.borderWidth = 4
        thumbView.layer.borderColor = UIColor.white.cgColor
        thumbView.addGestureRecognizer(panGesture)
        
        self.addSubview(thumbView)
    }
    
    private func manageBrightnessView(){
        brightnessView = UIView(frame: self.bounds)
        brightnessView.backgroundColor = .black
        brightnessView.alpha = 0
        backgroundColouredView.addSubview(brightnessView)
    }
    
    public func setSliderValueBy(colour: UIColor){
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 1, 1, 1)
        colour.getHue(&hsba.h, saturation: &hsba.s, brightness: &hsba.b, alpha: &hsba.a)
        thumbView.layer.position.x = self.backgroundColouredView.bounds.width * (hsba.h * 100) / 100
        self.alpha = hsba.a
        self.saturation = hsba.s
        self.brightness = hsba.b
        
        self.colourChosen = colour
        thumbView.backgroundColor = colourChosen
    }
    
    public func setSliderValueByColourValues(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat){
        thumbView.layer.position.x = self.backgroundColouredView.bounds.width * (hue * 100) / 100
        self.alpha = alpha
        self.saturation = saturation
        self.brightness = brightness
        
        self.colourChosen = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        thumbView.backgroundColor = colourChosen
        
    }
    
    public func setCornerRadius(by value: CGFloat){
        backgroundColouredView.clipsToBounds = true
        backgroundColouredView.layer.cornerRadius = value
        
    }
    
    //GETTING CURRENT VALUES
    
    public func getCurrentRGBAValues() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat){
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1
        if let components = colourChosen.cgColor.components{
            if components.count > 3{
                r = components[0]
                g = components[1]
                b = components[2]
                a = components[3]
            }
        }
        return (red: r, green: g, blue: b, alpha: a)
    }
    
    public func getCurrentHSBAValues() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat){
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 1, 1, 1)
        colourChosen.getHue(&hsba.h, saturation: &hsba.s, brightness: &hsba.b, alpha: &hsba.a)
        return (hue: hsba.h, saturation: hsba.s, brightness: hsba.b, alpha: hsba.a)
    }
    
    // GESTURE
    @objc open func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: thumbView)
        if let view = gestureRecognizer.view{
            if view.frame.midX < 0{
                view.layer.position.x = 0
            }else if view.frame.midX > self.bounds.width{
                view.layer.position.x = self.bounds.width
            }else{
                let translationX = view.center.x + translation.x
                view.center = CGPoint(x:translationX,
                                      y:view.center.y)
                colourChosen = UIColor(hue: translationX / self.backgroundColouredView.bounds.width, saturation: saturation, brightness: brightness, alpha: alpha)
                thumbView.backgroundColor = colourChosen
                
                activateAllDelegateMethods(hue: translationX / self.backgroundColouredView.bounds.width, saturation: saturation, brightness: brightness, alpha: alpha)
                
            }
            
        }
        gestureRecognizer.setTranslation(CGPoint.zero, in: thumbView)
        

    }
    
    //DELEGATE
    
    private func activateAllDelegateMethods(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat){
        delegate?.colourValuesChanged?(to: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        let gottenUIColour = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        delegate?.colourGotten?(colour: gottenUIColour)
        if let components = gottenUIColour.cgColor.components{
            if components.count > 3{
                delegate?.colourValuesChanged?(to: components[0], green: components[1], blue: components[2], alpha: components[3])
            }
        }
        
        
    }
    

}
