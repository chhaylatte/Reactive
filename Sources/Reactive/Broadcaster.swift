//
//  Broadcaster.swift
//  Reactive
//
//  Created by Danny Chhay on 6/29/19.
//

class Broadcaster<T> {
    private class ProxyListener {
        weak var listener: AnyObject?
        var handler: (T) -> Void

        init<U: AnyObject>(listener: U, handler: @escaping (U, T) -> Void) {
            self.listener = listener
            self.handler = { [weak listener] value in
                guard let listener = listener else { return }
                handler(listener, value)
            }
        }
    }

    private var proxyListeners = [ProxyListener]()

    func addListener<U: AnyObject>(_ listener: U, handler: @escaping (U, T) -> Void) {
        pruneListeners()

        let proxy = ProxyListener(listener: listener, handler: handler)
        proxyListeners.append(proxy)
    }

    func broadcast(value: T) {
        pruneListeners()

        proxyListeners.forEach { $0.handler(value) }
    }

    private func pruneListeners() {
        let index = proxyListeners.partition(by: { $0.listener == nil })
        guard index != proxyListeners.endIndex else { return }
        proxyListeners.removeSubrange(index...)
    }
}
