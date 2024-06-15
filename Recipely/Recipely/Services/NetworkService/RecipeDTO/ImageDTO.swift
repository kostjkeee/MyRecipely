// ImageDTO.swift

import Foundation

/// DTO Изображений
class ImageDTO: Codable {
    /// Изображение номрального размера
    let regular: RegularImageDTO?

    /// Ключи для JSON
    enum CodingKeys: String, CodingKey {
        /// Ключ для фото размера Regular
        case regular = "REGULAR"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        regular = try container.decodeIfPresent(RegularImageDTO.self, forKey: .regular)
    }
}
