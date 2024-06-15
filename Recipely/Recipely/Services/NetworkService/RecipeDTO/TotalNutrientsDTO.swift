// TotalNutrientsDTO.swift

import Foundation

/// DTO общего количества питательных веществ
class TotalNutrientsDTO: Codable {
    /// Углеводы
    let chocdf: NutrientDTO?
    /// Жиры
    let fat: NutrientDTO?
    /// Протеины
    let procnt: NutrientDTO?

    /// Ключи для JSON
    enum CodingKeys: String, CodingKey {
        /// Ключ для углеводов
        case chocdf = "CHOCDF"
        /// Ключ для жиров
        case fat = "FAT"
        /// Ключ для протеинов
        case procnt = "PROCNT"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        chocdf = try container.decodeIfPresent(NutrientDTO.self, forKey: .chocdf)
        fat = try container.decodeIfPresent(NutrientDTO.self, forKey: .fat)
        procnt = try container.decodeIfPresent(NutrientDTO.self, forKey: .procnt)
    }
}
