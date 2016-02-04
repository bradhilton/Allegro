# Piper
In Swift development it's all to familiar to see nested GCD code like the following:
```swift
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
    // Do some background work...
    dispatch_async(dispatch_get_main_queue()) { () -> Void in
        // Display results on main queue...
    }
}
```
`Piper` removes nesting and lets you chain arbitrary operations on any queue you like:
```swift
background {
  // Do some background work...
}.main {
  // Display results on main queue...
}.execute()
```
## Installation

`Piper` is available through [CocoaPods](http://cocoapods.org). To install, simply include the following lines in your podfile:
```ruby
use_frameworks!
pod 'Piper'
```
Be sure to import the module at the top of your .swift files:
```swift
import Piper
```
Alternatively, clone this repo or download it as a zip and include the classes in your project.

## Revision History

* 1.0.0 - Initial Release

## Author

Brad Hilton, brad@skyvive.com

## License

Piper is available under the MIT license. See the LICENSE file for more info.


