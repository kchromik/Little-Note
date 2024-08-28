//
//  UserDefaults+Extension.swift
//  LittleBase
//
//  Created by Kevin Chromik on 28.08.24.
//

import Foundation
import Combine

public extension UserDefaults {

    @UserDefault(key: "deviceID", defaultValue: nil)
    static var deviceID: String?
}

@propertyWrapper
public struct UserDefault<Value> {

    public let key: String
    public let defaultValue: Value
    public var container: UserDefaults = .standard
    private let publisher = PassthroughSubject<Value, Never>()

    public init(key: String, defaultValue: Value, container: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.container = container
    }

    public var wrappedValue: Value {
        get {
            container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            // Check whether we're dealing with an optional and remove the object if the new value is nil.
            if let optional = newValue as? AnyOptional, optional.isNil {
                container.removeObject(forKey: key)
            } else {
                container.set(newValue, forKey: key)
            }
            publisher.send(newValue)
        }
    }

    public var projectedValue: AnyPublisher<Value, Never> {
        publisher.eraseToAnyPublisher()
    }
}

public extension UserDefault where Value: ExpressibleByNilLiteral {

    /// Creates a new User Defaults property wrapper for the given key.
    /// - Parameters:
    ///   - key: The key to use with the user defaults store.
    init(key: String, _ container: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, container: container)
    }
}

public protocol AnyOptional {
    /// Returns `true` if `nil`, otherwise `false`.
    var isNil: Bool { get }
}
extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }
}
