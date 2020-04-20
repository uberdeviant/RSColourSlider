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
            self.colourChosen = UIColor(hue: getHueValueFrom(xValue: thumbView.layer.position.x), saturation: saturation, brightness: newValue, alpha: alpha)
            self.thumbView.backgroundColor = colourChosen
        }
    }
    open var saturation: CGFloat = 1.0{
        willSet{
            self.saturationView.alpha = 1 - newValue
            self.colourChosen = UIColor(hue: getHueValueFrom(xValue: thumbView.layer.position.x), saturation: newValue, brightness: brightness, alpha: alpha)
            self.thumbView.backgroundColor = colourChosen
        }
    }
    open var alphaColourValue: CGFloat = 1.0{
        willSet{
            self.backgroundColouredView.alpha = newValue
            self.colourChosen = UIColor(hue: getHueValueFrom(xValue: thumbView.layer.position.x), saturation: saturation, brightness: brightness, alpha: newValue)
            self.thumbView.backgroundColor = colourChosen
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        awakeAllParts()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        let widthAndHeightOfThumb = getHeightAndWidthOfThumb()
        self.backgroundColouredView.frame = CGRect(x: widthAndHeightOfThumb / 2, y: self.bounds.minY, width: self.bounds.width - widthAndHeightOfThumb, height: self.bounds.height)
        self.brightnessView.frame = backgroundColouredView.bounds
        self.saturationView.frame = backgroundColouredView.bounds
        self.gradientLayer.frame = backgroundColouredView.bounds
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 1, 1, 1)
        colourChosen.getHue(&hsba.h, saturation: &hsba.s, brightness: &hsba.b, alpha: &hsba.a)
        self.thumbView.center.x = backgroundColouredView.bounds.width * ((hsba.h + self.thumbView.bounds.width / 2 / backgroundColouredView.bounds.width) * 100) / 100
    }
    //BUILDING
    
    private func awakeAllParts(){
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        manageColouredBackgroundView()
        manageGradient()
        manageSaturationView()
        manageBrightnessView()
        addThumbView()
        setSliderValueBy(colour: colourChosen)
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
        let widthAndHeightOfThumb: CGFloat = getHeightAndWidthOfThumb()
        backgroundColouredView = UIView(frame: CGRect(x: widthAndHeightOfThumb / 2, y: self.bounds.minY, width: self.bounds.width - widthAndHeightOfThumb, height: self.bounds.height))
        backgroundColouredView.backgroundColor = .clear
        self.addSubview(backgroundColouredView)
    }
    
    private func manageSaturationView(){
        saturationView = UIView(frame: backgroundColouredView.bounds)
        saturationView.backgroundColor = .white
        saturationView.alpha = 0
        backgroundColouredView.addSubview(saturationView)
    }
    
    private func addThumbView(){
        let widthAndHeightOfThumb: CGFloat = getHeightAndWidthOfThumb()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        thumbView = UIView(frame: CGRect(x: 0, y: 0, width: widthAndHeightOfThumb, height: widthAndHeightOfThumb))
        thumbView.isUserInteractionEnabled = true
        thumbView.layer.cornerRadius = widthAndHeightOfThumb / 2
        thumbView.backgroundColor = UIColor(hue: thumbView.bounds.midX / backgroundColouredView.bounds.width, saturation: saturation, brightness: brightness, alpha: alpha)
        thumbView.layer.position = CGPoint(x: widthAndHeightOfThumb / 2, y: backgroundColouredView.bounds.midY)
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
        brightnessView = UIView(frame: backgroundColouredView.bounds)
        brightnessView.backgroundColor = .black
        brightnessView.alpha = 0
        backgroundColouredView.addSubview(brightnessView)
    }
    
    public func setSliderValueBy(colour: UIColor){
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 1, 1, 1)
        colour.getHue(&hsba.h, saturation: &hsba.s, brightness: &hsba.b, alpha: &hsba.a)
        
        thumbView.layer.position.x = backgroundColouredView.bounds.width * ((hsba.h + self.thumbView.bounds.width / 2 / backgroundColouredView.bounds.width) * 100) / 100
        self.alpha = hsba.a
        self.saturation = hsba.s
        self.brightness = hsba.b
        
        self.colourChosen = colour
        thumbView.backgroundColor = colourChosen
    }
    
    public func setSliderValueByColourValues(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat){
        thumbView.layer.position.x = self.backgroundColouredView.bounds.width * ((hue + self.thumbView.bounds.width / 2 / backgroundColouredView.bounds.width) * 100) / 100
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
    
    private func getHeightAndWidthOfThumb() -> CGFloat{
        return self.bounds.height < 50 ? self.bounds.height - 10 : 40
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
        
        let translation = gestureRecognizer.translation(in: backgroundColouredView)
        if let view = gestureRecognizer.view{
            if view.frame.midX < thumbView.bounds.width / 2{
                view.layer.position.x = thumbView.bounds.width / 2
            }else if view.frame.midX > backgroundColouredView.bounds.width + thumbView.bounds.width / 2{
                view.layer.position.x = backgroundColouredView.bounds.width + thumbView.bounds.width / 2
            }
            let translationX = view.center.x + translation.x
            view.center = CGPoint(x:translationX,
                                  y:view.center.y)
            var totalTranslation: CGFloat = getHueValueFrom(xValue: translationX)
            if totalTranslation > 1{
                totalTranslation = 1
            }else if totalTranslation < 0{
                totalTranslation = 0
            }
            
            colourChosen = UIColor(hue: totalTranslation, saturation: saturation, brightness: brightness, alpha: alpha)
            thumbView.backgroundColor = colourChosen
            
            activateAllDelegateMethods(hue: totalTranslation, saturation: saturation, brightness: brightness, alpha: alpha)
            
        }
        gestureRecognizer.setTranslation(CGPoint.zero, in: backgroundColouredView)
    
    }
    
    private func getHueValueFrom(xValue: CGFloat) -> CGFloat{
        return (xValue / backgroundColouredView.bounds.width) - (self.thumbView.bounds.width / 2 / backgroundColouredView.bounds.width)
    }
    
    //INIT
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        awakeAllParts()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
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
