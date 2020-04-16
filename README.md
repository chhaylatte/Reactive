# Reactive

A small Swift Package for using "reactive style" without using a functional reactive programming framework.

## What
The generic object `Reactive` implements an observer system to notify listeners of initial and updated values.  There is no stream of data, just single update propagation.  `Reactive` can also be used as a property wrapper.

## Why
Reactive style can help keep code maintainable by using unidirectional dataflow, but learning a functional reactive framework may be daunting or too time consuming.  Since `Reactive` is a very small library, it takes very little time to learn and is easy to understand.  `Reactive` does not add any extra overhead of unsubscribing, retaining, or releasing any objects.

## How
### Reactive Object
Initialize a `Reactive` type with any type that is intended to be observed.  Ex. a `String` that can be changed and used to update a label.
```swift
let title = Reactive("Title")   // `title` is of type `Reactive<String>` in this case
print(title.value)      // Print the wrapped value.  title.wrappedValue works too.
```

To start listening, call the `bind(_ listener:, skipInitialValue:, handler:)`  method.  The handler is called after every `update` call on the `Reactive` object.
```swift
let label = UILabel()
title.bind(label) { (aLabel, string) in // This handler will be called with the listener and value as parameters
    alabel.text = string    // Update the text of the listener.
}
```

To change the `value` call the `update(_ value:)` method.
```swift
title.update("New Title")   // All the handlers that is bound to `title` object is called after the value is updated.
```

To stop listening for values, call the `unbind(_ listener:)` method.
```swift
title.unbind(label)    // All handlers associated to the label are now removed
```

### Reactive Property Wrapper
The following properties are all equivalent, except the `@Reactive` property wrapper offers syntactic sugar.
```swift
class MyClass {
    @Reactive var title: String = ""
    var title2: Reactive<String> = Reactive("")
    var title3 = Reactive("")
}

let myClass = MyClass()
print(myClass.title)        // prints ""

myClass.title = "New Title"
print(myClass.title)        // prints "New Title"

```

To bind or unbind a reactive property, use its property projection.
```swift
let label = UILabel()
myClass.$title.bind(label) { (aLabel, string) in
    aLabel.text = string
}

myClass.$title.unbind(label)
```
