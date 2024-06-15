// KeyChainWrapper.swift

import Foundation
import Keychain

/// Обертка для сохраниения данных в Keychain
@propertyWrapper
public struct KeyChain<T: Codable> {
    public init(_ key: String = "", defaultValue: T? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T? {
        get {
            let decoder = JSONDecoder()
            guard let data = Keychain.load(key)?.data(using: .utf8),
                  let decoded = try? decoder.decode(T.self, from: data) else { return nil }
            return decoded
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue), let textData = String(data: encoded, encoding: .utf8) {
                _ = Keychain.save(textData, forKey: key)
            }
        }
    }

    var key: String
    let defaultValue: T?
}
