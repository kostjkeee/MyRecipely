// Memento.swift

import Foundation

// Хранитель
struct Memento: Codable {
    private var mementoData: Data

    init?(mementoObject: Codable) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(mementoObject) {
            mementoData = encoded
        } else {
            return nil
        }
    }

    // MARK: - Public Methods

    func getContent<T: Decodable>() -> T? {
        let decoder = JSONDecoder()
        let decoded = try? decoder.decode(T.self, from: mementoData)
        return decoded
    }
}
