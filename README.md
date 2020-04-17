# Reactive

A small Swift Package for using "reactive style" without using a functional reactive programming framework.

## What
The generic object `Reactive` implements an observer system to notify listeners of initial and updated values.  There is no stream of data, just single update propagation.  `Reactive` is also a property wrapper.

## Why
Reactive style can help keep code maintainable by reducing the amount of code and complexity.  Team or project constraints may not allow the use of a reactive framework such as `Combine` or `RxSwift`, so `Reactive` can be an alternative.  `Reactive` works with Swift 5.1, and takes very little time to learn.  `Reactive` does not need any extra coding overhead of unsubscribing, retaining, or releasing any objects.  `Reactive` is smart enough to discard handlers if the associated listener is deallocated.

## How
`Reactive` is conceptually just a wrapper that also supports a built in observer method.  `Reactive` can be used as either an object or as a property wrapper.  Simply use the bind method on `Reactive` to define how to handle values.

### Reactive Object
Initialize a `Reactive` type with any type that is intended to be observed.  Ex. a `String` that stores info and is observed to update a label.
```swift
class MyClass {
    let title = Reactive("Title")   // `title` is of type `Reactive<String>` in this case
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
myClass.title.update("New Title")   // All the handlers that is bound to `title` object is called after the value is updated.
```

To stop listening for values, call the `unbind(_ listener:)` method.
```swift
myClass.title.unbind(titleLabel)    // All handlers associated to the label are now removed
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
myClass.title = "Newest Title"  // Triggers the previously bound handler

myClass.$title.unbind(titleLabel)    // All handlers associated to label are removed
```
