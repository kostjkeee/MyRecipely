// HitDTO.swift

import Foundation

/// DTO объекта с рецептом
struct HitDTO: Codable {
    /// Рецепт
    let recipe: RecipeDTO?
}
