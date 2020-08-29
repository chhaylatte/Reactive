# Reactive

A small Swift Package for data binding.

## Installation
### Method 1: Swift Package Manager
1. In Xcode, go to File > Swift Packages > Add Package Dependency.
2. Enter `https://github.com/chhaylatte/Reactive/` for the repository URL.
3. Select the desired version and press `Next`.

### Method 2: Carthage [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
1. Add `github "chhaylatte/Reactive"` in the `Cartfile`.
3. Open `Carthage/Build` and locate the relevant `Reactive.framework` for the desired platform.
4. Drag the `Reactive.framework` bundle into the `Frameworks, Libraries, and Embedded Content` section of the `Project Target` in Xcode.

## What
`Reactive` is a wrapper object that implements an observer system to notify listeners of initial and updated values.  There is no stream of data, just single update propagation.

## Why
Reactive style can help keep code maintainable by reducing the amount of code and complexity.  Team or project constraints, such as requiring older versions of iOS, may not allow the use of a reactive framework such as `Combine` or `RxSwift`, so `Reactive` can be an alternative.  `Reactive` works with Swift 5.1, and takes very little time to learn.  `Reactive` does not need any extra coding overhead of unsubscribing, retaining, or releasing any objects.  `Reactive` is smart enough to discard handlers if the associated listener is deallocated.

## How
`Reactive` is conceptually just a wrapper object that provides a built in observer method.  Simply use the bind method on `Reactive` to define how to handle new and initial values.  `Reactive` can be used as either a wrapper object, or as a Swift property wrapper.

### Reactive Object
Initialize a `Reactive` wrapper with any type that is intended to be observed.  For example, a `String` value that is needed to set the text of a label.
```swift
class MyClass {
    let title = Reactive("Title")   // `title` is implicitly of type `Reactive<String>` in this case
}
let myClass = MyClass()
print(myClass.title.wrappedValue)      // Prints "Title"
```

To start listening, call the `bind(_ listener:, skipInitialValue:, handler:)`  method.  The handler is called after every `update` call on the `Reactive` object.
```swift
let titleLabel = UILabel()
myClass.title.bind(titleLabel) { (aLabel, string) in // This handler will be called with the listener and new/initial values as parameters
    alabel.text = string    // Update the text of the listener.
}
```

To change the `value` call the `update(_ value:)` method.
```swift
myClass.title.update("New Title")   // The handler is now triggered, updating the text of the label
```

To stop listening for values, call the `unbind(_ listener:)` method.
```swift
myClass.title.unbind(titleLabel)    // All handlers associated to `titleLabel` are now removed
```

### Reactive Property Wrapper
The `@Reactive` property wrapper offers syntactic sugar.  Internally, it is the same as the `Reactive` object
```swift
class MyClass {
    @Reactive var title: String = ""
}

let myClass = MyClass()
print(myClass.title)        // prints ""

myClass.title = "New Title" // Updates the title
print(myClass.title)        // prints "New Title"

```

To bind or unbind a reactive property, use its property projection.
```swift
let titleLabel = UILabel()
myClass.$title.bind(titleLabel) { (aLabel, string) in   // This handler will be called with the listener and new/initial values as parameters
    aLabel.text = string
}
myClass.title = "Newest Title"  // titleLabel's text is now updated to "Newest Title"

myClass.$title.unbind(titleLabel)    // All handlers associated to `titleLabel` are removed
```
