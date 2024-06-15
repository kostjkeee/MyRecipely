// RecipeDTO.swift

import Foundation

/// DTO Рецепта
struct RecipeDTO: Codable {
    /// Название рецепта
    let label: String?
    /// Ссылка на картинку
    let image: String?
    /// Время приготовления
    let totalTime: Double?
    /// Калорийность
    let calories: Double?
    /// Картинки
    let images: ImageDTO?
    /// Вес блюда
    let totalWeight: Double?
    /// Общее количество питательных веществ
    let totalNutrients: TotalNutrientsDTO?
    /// Ингредиенты
    let ingredientLines: [String]?
    /// URI
    let uri: String?
}
