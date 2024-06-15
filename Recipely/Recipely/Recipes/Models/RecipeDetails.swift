// RecipeDetails.swift

import Foundation

/// Детали рецепта
struct RecipeDetails: Codable {
    /// Название рецепта
    let label: String
    /// Ссылка на картинку
    let image: String
    /// Вес блюда
    let weight: String
    /// Время приготовления
    let totalTime: Int
    /// Калорийность
    let calories: Int
    /// Углеводы
    let carbohydrates: String
    /// Жиры
    let fats: String
    /// Белки
    let proteins: String
    /// Описание рецепта
    let ingredients: String
    /// URI
    let uri: String

    init?(dto: RecipeDTO) {
        guard let label = dto.label,
              let image = dto.images?.regular?.url,
              let weight = dto.totalWeight,
              let totalTime = dto.totalTime,
              let calories = dto.calories,
              let carbohydrates = dto.totalNutrients?.chocdf?.quantity,
              let fats = dto.totalNutrients?.fat?.quantity,
              let proteins = dto.totalNutrients?.procnt?.quantity,
              let ingredients = dto.ingredientLines,
              let uri = dto.uri
        else { return nil }

        self.label = label
        self.image = image
        self.weight = "\(weight.rounded()) g"
        self.totalTime = Int(totalTime.rounded())
        self.calories = Int(calories.rounded())
        self.carbohydrates = "\(carbohydrates.rounded()) g"
        self.fats = "\(fats.rounded()) g"
        self.proteins = "\(proteins.rounded()) g"
        self.uri = uri

        var ingredientsText = String()
        for ingredient in ingredients {
            ingredientsText.append("\(ingredient)\n")
        }
        self.ingredients = ingredientsText
    }
}
