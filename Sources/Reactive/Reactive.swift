//
//  Reactive.swift
//  Reactive
//
//  Created by Danny Chhay on 6/29/19.
//  Copyright © 2019 Danny Chhay. All rights reserved.
//
@propertyWrapper
public class Reactive<T> {

    private(set) var value: T

    public var wrappedValue: T {
        get { return value }
        set { update(newValue) }
    }

    /// Used to exposed API when using `Reactive` as a property wrapper.
    public var projectedValue: Reactive<T> {
        get { return self }
    }

    private lazy var broadcaster = Broadcaster<T>()

    /// Initializes a `Reactive` type.
    /// - Parameter wrappedValue: The initial value.
    public init(wrappedValue initialValue: T) {
        value = initialValue
    }

    /// Initializes a `Reactive` type.
    /// - Parameter initialValue: The initial value.
    public convenience init(_ initialValue: T) {
        self.init(wrappedValue: initialValue)
    }

    /// Updates `value` and then notifies all listeners
    /// - Parameter value: The new value to set.
    public func update(_ value: T) {
        self.value = value
        broadcaster.broadcast(value: value)
    }

    /// Sets `value` without notifying listeners
    /// - Parameter value: The new value
    public func set(_ value: T) {
        self.wrappedValue = value
    }

    /// Subscribes a `listener` to receive new values via the `handler`.
    /// - Parameters:
    ///   - listener: The original observer of value changes.
    ///   - skipInitialValue: A `Bool` to indicate if the current value should be observed.
    ///   - handler: This closure is called whenever the `value` is updated.
    public func bind<U: AnyObject>(_ listener: U?, skipInitialValue: Bool = false, handler: @escaping (U, T) -> Void) {
        guard let listener = listener else { return }

        broadcaster.addListener(listener, handler: handler)
        if !skipInitialValue {
            handler(listener, wrappedValue)
        }
    }

    public func unbind<U: AnyObject>(_ listener: U?) {
        guard let listener = listener else { return }

        broadcaster.removeListener(listener)
    }
}

