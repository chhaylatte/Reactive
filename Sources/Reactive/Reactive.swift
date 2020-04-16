//
//  Reactive.swift
//  Reactive
//
//  Created by Danny Chhay on 6/29/19.
//  Copyright © 2019 Danny Chhay. All rights reserved.
//
public class Reactive<T> {
    public var value: T

    private lazy var broadcaster = Broadcaster<T>()

    /// Initializes a `Reactive` type.
    /// - Parameter initialValue: The initial value.
    init(_ initialValue: T) {
        value = initialValue
    }

    /// Updates `value` and then notifies all listeners
    /// - Parameter value: The new value to set.
    func update(_ value: T) {
        self.value = value
        broadcaster.broadcast(value: value)
    }

    /// Sets `value` without notifying listeners
    /// - Parameter value: The new value
    func set(_ value: T) {
        self.value = value
    }

    /// Subscribes a `listener` to receive new values via the `handler`.
    /// - Parameters:
    ///   - listener: The original observer of value changes.
    ///   - skipInitialValue: A `Bool` to indicate if the current value should be observed.
    ///   - handler: This closure is called whenever the `value` is updated.
    func bind<U: AnyObject>(_ listener: U?, skipInitialValue: Bool = false, handler: @escaping (U, T) -> Void) {
        guard let listener = listener else { return }

        broadcaster.addListener(listener, handler: handler)
        if !skipInitialValue {
            handler(listener, value)
        }
    }
}

