// UserDefaultWrapperWrapper.swift

import Foundation

/// Обертка для сохраниения данных в userDefaults
@propertyWrapper
public struct Storage<T: Codable> {
    public init(_ key: String = "", defaultValue: T? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T? {
        get {
            let decoder = JSONDecoder()
            guard let data = UserDefaults.standard.data(forKey: key),
                  let decoded = try? decoder.decode(T.self, from: data) else { return nil }
            return decoded
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: key)
                UserDefaults.standard.synchronize()
            }
        }
    }

    var key: String
    let defaultValue: T?
}
