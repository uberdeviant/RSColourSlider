//
//  ViewController.swift
//  RSColourSliderExample
//
//  Created by Ramil Salimov on 18.04.2020.
//  Copyright © 2020 Ramil Salimov. All rights reserved.
//

import UIKit
import RSColourSlider

class ViewController: UIViewController, RSColourSliderDelegate {

    @IBOutlet weak var colourView: UIView!
    @IBOutlet weak var rgbaLabel: UILabel!
    @IBOutlet weak var hsbaLabel: UILabel!
    
    @IBOutlet weak var colourSlider: RSColourSlider!
    
    var neededColour = UIColor.blue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colourView.layer.cornerRadius = colourView.bounds.height / 2
        colourView.clipsToBounds = true
        
        //**//
        colourSlider.delegate = self
        colourSlider.setCornerRadius(by: colourSlider.bounds.height / 2)
        colourSlider.setSliderValueBy(colour: neededColour)
        //**//
        updateUI()
        
    }
    
    private func updateUI(){
        colourView.backgroundColor = neededColour
    }

    private func updateRGBALabel(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat){
        rgbaLabel.text = "red: \(Int(r*100))%, green: \(Int(g*100))%,\nblue: \(Int(b*100))%, alpha: \(Int(a*100))%"
    }
    
    private func updateHSBALabel(h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat){
        hsbaLabel.text = "hue: \(Int(h*100))%, saturation: \(Int(s*100))%,\nbrightness: \(Int(b*100))%, alpha: \(Int(a*100))%"
    }
    //MARK: - COLOUR SLIDER DELEGATES
    func colourGotten(colour: UIColor) {
        neededColour = colour
        updateUI()
    }
    
    func colourValuesChanged(to red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        updateRGBALabel(r: red, g: green, b: blue, a: alpha)
    }
    
    func colourValuesChanged(to hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        updateHSBALabel(h: hue, s: saturation, b: brightness, a: alpha)
    }
    //MARK: - Getting current values from the colour slider
    
    func getCurrentValues(){
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


