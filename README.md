### App Injector

## Usage

```swift
import AppInjector

class Car: NSObject {
    var name = ""
    var engine: Engine?
}

class Engine: NSObject { }

...

// Use Injector.defaultInjector or manage own life cycle
let injector = Injector()

// Inject via factory
injector.bind("engine") { Engine() }

// Inject constant
injector.bind("name", value: "private")

// Inject via NSObject constructor, and properties
injector.bind("car", type: Car.self).withDependencies(["name", "engine"])

// Resolve a car instance, all dependencies injected
let car = injector.resolve(Car.self)

assert(car.engine != nil)
assert(car.name == "private")
```

## Installation

AppInjector is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following lines to your Podfile:

```ruby
use_frameworks!
pod "AppInjector"
```
