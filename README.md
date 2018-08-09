# GravitySlider
this is a cool range (Price, Age, Size, Weight) slider written with Swift 4 <3
 <br/>

![Alt Text](https://cdn.rawgit.com/farshadjahanmanesh/GravitySlider/155eb6c9/GravitySlider/highlighted.gif)
![Alt Text](https://cdn.rawgit.com/farshadjahanmanesh/GravitySlider/155eb6c9/GravitySlider/normal.gif)
<br/>

# Options
```swift
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
```
# Usage 
Just move/copy the GravitySlider.swift file to your project
you can use it in InterfaceBuilder and change whatever you want like this
```swift
@IBOutlet weak var slider : GravitySlider?
override func viewDidLoad() {
        super.viewDidLoad()
        var defaultSettings = GravitySlider.Settings()
        defaultSettings.colors.circle = .red
        defaultSettings.colors.textContainerhighlighter = .red
        slider?.settings = defaultSettings
    }
```
