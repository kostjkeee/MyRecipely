// InformationSource.swift

import Foundation

/// Наполнение ячеек с рецептами
struct InformationSource {
    let categories: [DishCategory] = [
        DishCategory(imageName: "salad", type: .salad),
        DishCategory(imageName: "soup", type: .soup),
        DishCategory(imageName: "chicken", type: .chicken),
        DishCategory(imageName: "meat", type: .meat),
        DishCategory(imageName: "fish", type: .fish),
        DishCategory(imageName: "sideDish", type: .sideDish),
        DishCategory(imageName: "drinks", type: .drinks),
        DishCategory(imageName: "pancake", type: .pancake),
        DishCategory(imageName: "desserts", type: .desserts),
    ]
}
