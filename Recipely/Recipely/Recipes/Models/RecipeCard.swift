// RecipeCard.swift

import Foundation

/// Карточка рецепта
struct RecipeCard: Codable {
    /// Название рецепта
    let label: String
    /// Ссылка на картинку
    let image: String
    /// Изображение
    let imageData: Data?
    /// Время приготовления
    let totalTime: Int
    /// Калорийность
    let calories: Int
    /// uri
    let uri: String

    init?(dto: RecipeDTO) {
        guard let label = dto.label,
              let image = dto.image,
              let totalTime = dto.totalTime,
              let calories = dto.calories,
              let uri = dto.uri
        else { return nil }

        self.label = label
        self.image = image
        self.totalTime = Int(totalTime.rounded())
        self.calories = Int(calories.rounded())
        self.uri = uri
        imageData = nil
    }

    init(label: String, image: String, totalTime: Int, calories: Int, uri: String, imageData: Data?) {
        self.label = label
        self.image = image
        self.totalTime = totalTime
        self.calories = calories
        self.uri = uri
        self.imageData = imageData
    }
}
