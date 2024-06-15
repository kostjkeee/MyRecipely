// CategoriesDTO.swift

import Foundation

/// DTO категории рецептов
struct CategoriesDTO: Codable {
    /// Массив рецептов
    let hits: [HitDTO]?
}
