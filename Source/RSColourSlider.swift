//
//  RSColourSlider.swift
//  RSColourSlider
//
//  Created by Ramil Salimov on 18.04.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import UIKit

@objc public protocol RSColourSliderDelegate {
    
    ///Method passes HSBA values as parameters when the thumb moves
    @objc optional func colourValuesChanged(to hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
    
    ///Method passes RGBA values as parameters when the thumb moves
    @objc optional func colourValuesChanged(to red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    
    ///Method passes UIColour as a parameter when the thumb moves
    @objc optional func colourGotten(colour: UIColor)
}

open class RSColourSlider: UIView, UIGestureRecognizerDelegate {
    
    ///Private properties are just for slider
    private var brightnessView: UIView! //cosmetic brightness view
    private var saturationView: UIView! //cosmetic saturation view

    private var gradientLayer: CAGradientLayer!
    
    ///Public properties are just for user
    public var backgroundColouredView: UIView! //view that contains gradient layer
    public var thumbView: UIView! //THE CONTROLLER
    public var colourChosen: UIColor = UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 1)
    
    public weak var delegate: RSColourSliderDelegate?
    
    ///Opened properties are just for fun :)
    
    open var saturation: CGFloat = 1.0{
        willSet{
            self.saturationView.alpha = 1 - newValue
            
            //Tne saturation value can be changed outside the Colour Slider, but it can be used as a display
            self.colourChosen = UIColor(hue: getHueValueFrom(xValue: thumbView.layer.position.x), saturation: newValue, brightness: brightness, alpha: alphaColourValue)
            self.thumbView.backgroundColor = colourChosen
        }
    }
    
    open var brightness: CGFloat = 1.0{
        willSet{
            self.brightnessView.alpha = 1 - newValue
            
            //The brighntess value can be changed outside the Colour Slider, but it can be used as a display
            self.colourChosen = UIColor(hue: getHueValueFrom(xValue: thumbView.layer.position.x), saturation: saturation, brightness: newValue, alpha: alphaColourValue)
            self.thumbView.backgroundColor = colourChosen
        }
    }
    
    open var alphaColourValue: CGFloat = 1.0{
        willSet{
            self.backgroundColouredView.alpha = newValue
            
            //The alpha value can be changed outside the Colour Slider, but it can be used as a display
            self.colourChosen = UIColor(hue: getHueValueFrom(xValue: thumbView.layer.position.x), saturation: saturation, brightness: brightness, alpha: newValue)
            self.thumbView.backgroundColor = colourChosen
        }
    }
    
    //MARK: - BUILT-IN METHODS for the STORYBOARD
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        awakeAllParts()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        resizeWhenLayoutSubviews()
    }
    
    //MARK: - INIT for ADDING BY CODE
    
    /// Just init
    public override init(frame: CGRect){
        super.init(frame: frame)
        awakeAllParts()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - BUILDING
    
    private func resizeWhenLayoutSubviews(){
        
        /*
        This method is used for resizing all subviews
        when the superview has been resized by the autolayout system
        */
        
        let thumbHeight = getThumbHeight()
        
        //The anchor is backgroundColouredView, that's because we need to use thumb's pan gesture inside the superview of the Colour Slider
        self.backgroundColouredView.frame = CGRect(x: thumbHeight / 2, y: self.bounds.minY, width: self.bounds.width - thumbHeight, height: self.bounds.height)
        self.brightnessView.frame = backgroundColouredView.bounds
        self.saturationView.frame = backgroundColouredView.bounds
        self.gradientLayer.frame = backgroundColouredView.bounds
        
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 1, 1, 1) //container for refreshing
        colourChosen.getHue(&hsba.h, saturation: &hsba.s, brightness: &hsba.b, alpha: &hsba.a)//refresh
        
        self.thumbView.center.x = calculateThumbXPosition(by: hsba.h)
    }
    
    private func awakeAllParts(){
        /*
        The constructor method. It's calling in awakeFromNib() when a storyboard is used, also it
        might be called in init(), if the slider instance has been created programmatically
        */
        
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        
        manageColouredBackgroundView()
        manageGradient()
        manageSaturationView()
        manageBrightnessView()
        addThumbView()
        setSliderValueBy(colour: colourChosen)
    }
    
    
    ///Building backgroundColouredView
    private func manageColouredBackgroundView(){
        let thumbHeight: CGFloat = getThumbHeight()
        /*
         backgroundColouredView must be a little bit smaller than the superview of the slider. We need it
         for using the thumbView's pan gesture outside the coloured view.
         The difference shoud be equal to the width or height of the thumbView
         (the thumbView has 1:1 aspect ratio)
        */
        
        ///xValue starts from the half of thumbView height or width value
        backgroundColouredView = UIView(frame: CGRect(x: thumbHeight / 2, y: self.bounds.minY, width: self.bounds.width - thumbHeight, height: self.bounds.height))
        backgroundColouredView.backgroundColor = .clear
        self.addSubview(backgroundColouredView)
    }
    
    ///Building a gradient layer
    private func manageGradient(){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.backgroundColouredView.bounds.size.width, height: self.backgroundColouredView.bounds.size.height)
        
        var colours: [CGColor] = []
        var locations: [NSNumber] = []
        
        for index in 0...359{ // YES, It's O(n) where n equals to 359, but who is easy now?
             locations.append(NSNumber(value: (Double(index) / 359.0)))
             colours.append(UIColor(hue: CGFloat(index) / 359.0 , saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor)
        }
        gradientLayer.colors = colours
        gradientLayer.locations = locations
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        backgroundColouredView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    ///Just cosmetic view for manipulating the saturation
    private func manageSaturationView(){
        saturationView = getCosmeticView(colouredBy: .white)
        backgroundColouredView.addSubview(saturationView)
    }
    
    ///Just cosmetic view for manipulating the brightness
    private func manageBrightnessView(){
        brightnessView = getCosmeticView(colouredBy: .black)
        backgroundColouredView.addSubview(brightnessView)
    }
    
    ///DRY
    private func getCosmeticView(colouredBy colour: UIColor) -> UIView{
        let cosmeticView = UIView(frame: backgroundColouredView.bounds)
        cosmeticView.backgroundColor = colour
        cosmeticView.alpha = 0
        
        return cosmeticView
    }
    
    ///Thumb view is the HUE value controller
    private func addThumbView(){
        let thumbHeight: CGFloat = getThumbHeight()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        
        thumbView = UIView(frame: CGRect(x: 0, y: 0, width: thumbHeight, height: thumbHeight))
        thumbView.isUserInteractionEnabled = true
        thumbView.layer.cornerRadius = thumbHeight / 2
        thumbView.backgroundColor = UIColor(hue: thumbView.bounds.midX / backgroundColouredView.bounds.width, saturation: saturation, brightness: brightness, alpha: alphaColourValue)
        
        //xPosition will be equal to backgroundColourView frame.minX see manageColouredBackgroundView()
        thumbView.layer.position = CGPoint(x: thumbHeight / 2, y: backgroundColouredView.bounds.midY)
        
        //shadows
        thumbView.layer.shadowColor = UIColor.black.cgColor
        thumbView.layer.shadowOffset = .zero
        thumbView.layer.shadowOpacity = 0.3
        thumbView.layer.shadowRadius = 4.0
        
        //borders
        thumbView.layer.borderWidth = 4
        thumbView.layer.borderColor = UIColor.white.cgColor
        thumbView.addGestureRecognizer(panGesture)
        
        self.addSubview(thumbView)
    }
    
    ///Set the thumb position and slider's cometic views alpha by UIColour
    public func setSliderValueBy(colour: UIColor){
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 1, 1, 1)
        colour.getHue(&hsba.h, saturation: &hsba.s, brightness: &hsba.b, alpha: &hsba.a)
        
        //Superview's size and colouredView's size are different thant's why it should be calculated differently see calculateThumbXPosition(by hue: CGFloat)
        thumbView.layer.position.x = calculateThumbXPosition(by: hsba.h)
        
        self.alphaColourValue = hsba.a ///view will be changed in willSet of this value
        self.saturation = hsba.s ///view will be changed in willSet of this value
        self.brightness = hsba.b ///view will be changed in willSet of this value
        
        self.colourChosen = colour
        thumbView.backgroundColor = colourChosen
    }
    
    ///Set the thumb position and slider's cometic views alpha by manual HSBA parameters
    public func setSliderValueByColourValues(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat){
        
        thumbView.layer.position.x = calculateThumbXPosition(by: hue)
        
        self.alphaColourValue = alpha ///view will be changed in willSet of this value
        self.saturation = saturation ///view will be changed in willSet of this value
        self.brightness = brightness ///view will be changed in willSet of this value
        
        
        self.colourChosen = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        thumbView.backgroundColor = colourChosen
        
    }
    
    ///Just corner radius
    public func setCornerRadius(by value: CGFloat){
        backgroundColouredView.clipsToBounds = true
        backgroundColouredView.layer.cornerRadius = value
        
    }
    
    ///Get height of the thumb
    private func getThumbHeight() -> CGFloat{
        return self.bounds.height < 50 ? self.bounds.height - 10 : 40
    }
    
    ///Superview's size and colouredView's size are different thant's why it should be calculated differently
    private func calculateThumbXPosition(by hue: CGFloat) -> CGFloat{
        
        let thumbViewInsideSuperview = (hue + self.thumbView.bounds.width / 2 / backgroundColouredView.bounds.width) * 100
        
        //Just percent
        return self.backgroundColouredView.bounds.width * thumbViewInsideSuperview / 100
    }
    
    //MARK: - GETTING CURRENT VALUES
    
    ///Returns components of colourChosen in RGBA when calling
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
    
    ///Returns components of colourChosen in HSBA when calling
    public func getCurrentHSBAValues() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat){
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 1, 1, 1)
        colourChosen.getHue(&hsba.h, saturation: &hsba.s, brightness: &hsba.b, alpha: &hsba.a)
        return (hue: hsba.h, saturation: hsba.s, brightness: hsba.b, alpha: hsba.a)
    }
    
    //MARK: - GESTURE
    
    @objc open func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: backgroundColouredView)
        if let view = gestureRecognizer.view{
            if view.frame.midX < thumbView.bounds.width / 2{
                ///The controller is bouncing when user tries to pull the thumb outside the colouredView -x
                view.layer.position.x = thumbView.bounds.width / 2
            }else if view.frame.midX > backgroundColouredView.bounds.width + thumbView.bounds.width / 2{
                ///The controller is bouncing when user tries to pull the thumb outside the colouredView +x
                view.layer.position.x = backgroundColouredView.bounds.width + thumbView.bounds.width / 2
            }
            
            let translationX = view.center.x + translation.x
            view.center = CGPoint(x:translationX, y:view.center.y)
            var totalTranslation: CGFloat = getHueValueFrom(xValue: translationX)
            
            if totalTranslation > 1{
                totalTranslation = 1
            }else if totalTranslation < 0{
                totalTranslation = 0
            }
            
            colourChosen = UIColor(hue: totalTranslation, saturation: saturation, brightness: brightness, alpha: alphaColourValue)
            thumbView.backgroundColor = colourChosen
            
            //All delegate methods at once
            activateAllDelegateMethods(hue: totalTranslation, saturation: saturation, brightness: brightness, alpha: alphaColourValue)
            
        }
        gestureRecognizer.setTranslation(CGPoint.zero, in: backgroundColouredView)
    
    }
    
    ///Getting the differnece of position of pulled thumbView inside the superview but backgroundColouredView used as the anchor
    private func getHueValueFrom(xValue: CGFloat) -> CGFloat{
        return (xValue / backgroundColouredView.bounds.width) - (self.thumbView.bounds.width / 2 / backgroundColouredView.bounds.width)
    }
    
    
    //MARK: - DELEGATE
    
    ///Triggers all delegate methods
    private func activateAllDelegateMethods(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat){
        
        //HSBA
        delegate?.colourValuesChanged?(to: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        
        //UIColour
        delegate?.colourGotten?(colour: colourChosen)
        
        //RGBA
        if let components = colourChosen.cgColor.components{
            if components.count > 3{ //O(1)
                delegate?.colourValuesChanged?(to: components[0], green: components[1], blue: components[2], alpha: components[3])
            }
        }
    }
}
