# Reactive

A small Swift Package for using "reactive style" without using a functional reactive programming framework.

## What
The generic object `Reactive` implements an observer system to notify listeners of initial and updated values.  There is no stream of data, just single item update propagation.

## Why
Reactive style can help keep code maintainable by using unidirectional dataflow, but learning a functional reactive framework may be daunting or too time consuming.  Since `Reactive` is a very small library, it takes very little time to learn and is easy to understand.  `Reactive` does not add any extra overhead of unsubscribing, retaining, or releasing any objects.

## How

Initialize a `Reactive` type with any type that is intended to be observed.  Ex. a `String` that can be changed and used to update a label.
```swift
let title = Reactive("Title")   // `title` is of type `Reactive<String>` in this case
```

To start listening, call the `bind(_ listener:, skipInitialValue:, handler:)`  method.  The handler is called after every `update` call on the `Reactive` object.
```swift
let label = UILabel()
title.bind(label) { (aLabel, string) in // This handler will be called with the listener a value as parameters
    alabel.text = string    // Update the text of the listener.  `label` and `aLabel` are the same thing
}
```

To change the `value` call the `update(_ value:)` method.
```swift
title.update("New Title")   // All the handlers that is bound to `title` object is called after the value is updated.
```
