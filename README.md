![RSColourSlider Image](https://repository-images.githubusercontent.com/256673876/f3446200-8224-11ea-82f8-cc07a9d0ba46)

# RSColourSlider

[![CI Status](https://img.shields.io/travis/uberdeviant/RSColourSlider.svg?style=flat)](https://travis-ci.org/uberdeviant/RSColourSlider)
[![Version](https://img.shields.io/cocoapods/v/RSColourSlider.svg?style=flat)](https://cocoapods.org/pods/RSColourSlider)
[![License](https://img.shields.io/cocoapods/l/RSColourSlider.svg?style=flat)](https://cocoapods.org/pods/RSColourSlider)
[![Platform](https://img.shields.io/cocoapods/p/RSColourSlider.svg?style=flat)](https://cocoapods.org/pods/RSColourSlider)

# About:

**RSColourSlider** is able to give an opportunity for your app to use a colour picking functionality. The colour picker is implemented as a **regular slider**, which will be familiar to every iOS user. It's easy to install and setup because RSColourSlider inherits from **UIView** class. You can inherit your own class from RSColourSlider and change elements of the slider from your custom subclass, also you can setup it during a runtime in an instance of any UIViewController subclass. This interface element was created as a simplified iOS analogue of NSColorPicker for macOS.

## Features:

* Easy to use
* All rainbow colours can be applied
* Flexible customisation

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

# About:

**RSColourSlider** is able to give an opportunity for your app to use a colour picking functionality. The colour picker is implemented as a **regular slider**, which will be familiar to every iOS user. It's easy to install and setup because RSColourSlider inherits from **UIView** class. You can inherit your own class from RSColourSlider and change elements of the slider from your custom subclass, also you can setup it during a runtime in an instance of any UIViewController subclass. This interface element was created as a simplified iOS analogue of NSColorPicker for macOS.

## Features:

* Easy to use
* All rainbow colours can be applied
* Flexible customisation

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 12.0+, Swift 5.0+

## Installation

RSColourSlider is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following lines to your Podfile:


```ruby
platform :ios, '12.0'
use_frameworks!

pod 'RSColourSlider'
```

Then run the "install" command in the terminal:

```ruby
pod install
```

Check [Getting Started](https://guides.cocoapods.org/using/getting-started.html) for more information...

## Documentation:

First of all import the framework:

```swift
import RSColourSlider
```

# Object Creation:

You may create an instace of **RSColourSlider** traditionally, with code:

```swift
//example
let colourSlider = RSColourSlider(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
self.view.addSubview(view)
```

You may also drag a **UIView** into your **ViewController** in the storyboard, set the chosen view's **Class** and **Module** to RSColourSlider in **identity inspector** and then create its outlet:

```swift
@IBOutlet weak var colourSlider: RSColourSlider!
```

You have to set a slider's **delegate** to your instance of ViewController, for accesing its delegate methods when the slider value changes:

```swift
//for example in viewDidLoad()
override func viewDidLoad() {
    super.viewDidLoad()
    colourSlider.delegate = self
}
```

# Delegate:

**colourGotten(_:)**

To get a UIColor when the slider's value did change:

```swift
func colourGotten(colour: UIColor) {
    self.view.backgroundColour = colour
}
```

**colourValueChanged(_:) //RGBA**

To get RGBA values from the value of the slider:

```swift
func colourValuesChanged(to red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
    print(red, green, blue, alpha) //For example
}
```

**colourValueChanged(_:) //HSBA**

To get HSBA values from the value of the slider:

```swift
func colourValuesChanged(to hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
    print(hue, saturation, brightness, alpha) //For example
}
```

# Helpful Methods:

**getCurrentRGBAValues()**

Returns a tuple of current RGBA values, call it if you changed brightness, alpha or saturation by another **UISlider** and you want to set the current, chosen colour to some UI element, or read its values:

```swift
let rgbaValues = getCurrentRGBAValues()
print(rgbaValues.red, rgbaValues.green, rgbaValues.blue, rgbaValues.alpha)
```

**getCurrentHSBAValues()**

Returns a tuple of current HSBA values, call it if you changed brightness, alpha or saturation by another **UISlider** and you want to set the current, chosen colour to some UI element, or read its values:

```swift
let hsbaValues = getCurrentHSBAValues()
print(hsbaValues.hue, hsbaValues.saturation, hsbaValues.brightness, hsbaValues.alpha)
```

**setSliderValueBy(colour: UIColor)**

Moves the thumb to chosen value and updates the slider by passing colour as the argument:

```swift
//for example in viewDidLoad()
override func viewDidLoad() {
    super.viewDidLoad()
    colourSlider.setSliderValueBy(colour: UIColor.blue)
}
```

**setSliderValueByColourValues(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)**

Moves the thumb to chosen value and updates the slider by passing HSBA values as the arguments:

```swift
//for example in viewDidLoad()
override func viewDidLoad() {
    super.viewDidLoad()
    colourSlider.setSliderValueByColourValues(hue: 0.5, saturation: 1, brightness: 1, alpha: 1)
}
```
**TODO: setSliderValueByColourValues(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)**

**setCornerRadius(_ gestureRecognizer: UIPanGestureRecognizer)**

Safety method to set corner radius of the slider:

```swift
//for example in viewDidLoad()
override func viewDidLoad() {
    super.viewDidLoad()
    colourSlider.setCornerRadius(by: colourSlider.bounds.height / 2)
}
```

**handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer)**

Handles thumb's moving, can be overriden:

```swift
@objc open func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) 
```

# Properties

**delegate: RSColourSliderDelegate**

Triggers delegate's method

```swift
public var delegate: RSColourSliderDelegate?
```

**brightness: CGFloat**

Changing this value affects brightness of the slider:

```swift
open var brightness: CGFloat = 1.0 //defualt
```

**saturation: CGFloat**

Changing this value affects saturation of the slider:

```swift
open var saturation: CGFloat = 1.0 //default
```

**alphaColourValue: CGFloat**

Changing this value affects transparency of the slider:

```swift
open var alphaColourValue: CGFloat = 1.0 //default
```

**colourChosen: UIColor**

The current colour that slider shows: 

```swift
public var colourChosen: UIColor = UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 1) //default
```

**thumbView: UIView!**

The Thumb View. Can be modified: 

```swift
public var thumbView: UIView!
```

ThumbView has the following values:

```swift
//shadow
thumbView.layer.shadowColor = UIColor.black.cgColor
thumbView.layer.shadowOffset = .zero
thumbView.layer.shadowOpacity = 0.3
thumbView.layer.shadowRadius = 4.0
//borderWidth
thumbView.layer.borderWidth = 4
thumbView.layer.borderColor = UIColor.white.cgColor
thumbView.addGestureRecognizer(panGesture)
```

**backgroundColouredView: UIView!**

View that contains all layers and subview (not thumbView). Width of this view is a deviders when the slider calculates hue value:

```swift
public var backgroundColouredView: UIView!
```

# RSColourView inherits from UIView and it can use methods of UIView class!

# Logic

Value      | Min | Max |
Hue        |  0  |  1  |
Saturation |  0  |  1  |
Brightness |  0  |  1  |
Alpha      |  0  |  1  |

## License

RSColourSlider is available under the MIT license. See the LICENSE file for more info.

## Contacts:

### Ramil Uberdeviant Salimoff

* [Patreon](https://www.patreon.com/user?u=32639039)
* [Twitter](https://twitter.com/mruberdeviant)
* [Instagram](https://www.instagram.com/uberdeviant/)
* [Other Products](https://mr-uberdeviant.blogspot.com/p/swiftlighter.html)

