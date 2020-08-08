//
//  ViewController.swift
//  RSColourSliderExample
//
//  Created by Ramil Salimov on 18.04.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import UIKit
import RSColourSlider //Import RSColourSlider

class ViewController: UIViewController, RSColourSliderDelegate {

    @IBOutlet weak var colourView: UIView!
    @IBOutlet weak var rgbaLabel: UILabel!
    @IBOutlet weak var hsbaLabel: UILabel!
    
    //**//
    @IBOutlet weak var colourSlider: RSColourSlider!
    //**//
    
    var neededColour = UIColor.blue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///Not important, just setting up the UI of the element of the ViewController
        colourView.layer.cornerRadius = colourView.bounds.height / 2
        colourView.clipsToBounds = true
        
        //*IMPORTANT SETTING UP THE COLOUR SLIDER*//
        colourSlider.delegate = self
        colourSlider.setCornerRadius(by: colourSlider.bounds.height / 2)
        colourSlider.setSliderValueBy(colour: neededColour)
        //**//
        
        ///Not important
        updateUI()
        
    }
    
    ///Not important
    private func updateUI(){
        colourView.backgroundColor = neededColour
    }

    ///Not important
    private func updateRGBALabel(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat){
        rgbaLabel.text = "red: \(Int(r*100))%, green: \(Int(g*100))%,\nblue: \(Int(b*100))%, alpha: \(Int(a*100))%"
    }
    
    ///Not important
    private func updateHSBALabel(h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat){
        hsbaLabel.text = "hue: \(Int(h*100))%, saturation: \(Int(s*100))%,\nbrightness: \(Int(b*100))%, alpha: \(Int(a*100))%"
    }
    
    //MARK: - COLOUR SLIDER DELEGATES
    
    ///Optional delegate method that returns the UIColour when the slider changes values
    func colourGotten(colour: UIColor) {
        neededColour = colour
        updateUI()
    }
    ///Optional delegate method that returns RGBA values when the slider changes them
    func colourValuesChanged(to red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        updateRGBALabel(r: red, g: green, b: blue, a: alpha)
    }
    
    ///Optional delegate method that returns HSBA values when the slider changes them
    func colourValuesChanged(to hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        updateHSBALabel(h: hue, s: saturation, b: brightness, a: alpha)
    }
    //MARK: - Getting current values from the colour slider
    
    func getCurrentValues(){
        ///Get slider values whenever you need
        let valuesRGBA = colourSlider.getCurrentRGBAValues()
        let valuesHSBA = colourSlider.getCurrentHSBAValues()
        
        updateRGBALabel(r: valuesRGBA.red, g: valuesRGBA.green, b: valuesRGBA.blue, a: valuesRGBA.alpha)
        updateHSBALabel(h: valuesHSBA.hue, s: valuesHSBA.saturation, b: valuesHSBA.brightness, a: valuesHSBA.alpha)
    }
    
    
    //MARK: - Actions
    
    @IBAction func saturationSliderValueChanged(_ sender: UISlider) {
        colourSlider.saturation = CGFloat(sender.value)
        neededColour = colourSlider.colourChosen
        getCurrentValues()
        updateUI()
    }
    
    @IBAction func brightnessSliderValueChanged(_ sender: UISlider) {
        colourSlider.brightness = CGFloat(sender.value)
        neededColour = colourSlider.colourChosen
        getCurrentValues()
        updateUI()
    }
    
    @IBAction func alphaSliderValueChanged(_ sender: UISlider) {
        colourSlider.alphaColourValue = CGFloat(sender.value)
        neededColour = colourSlider.colourChosen
        getCurrentValues()
        updateUI()
    }
    
}


