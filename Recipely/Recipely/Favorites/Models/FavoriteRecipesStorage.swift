// FavoriteRecipesStorage.swift

import Foundation

protocol FavoriteRecipesStorageProtocol {
    var favoriteRecipes: [RecipeCard]? { get set }
}

/// Хранилище избранных рецептов
struct FavoriteRecipesStorage: FavoriteRecipesStorageProtocol {
    // MARK: - Public Properties

    @Storage()
    var favoriteRecipes: [RecipeCard]?

    // MARK: - Initializers

    init() {
        _favoriteRecipes.key = StorageKeys.favorite.rawValue
    }
}
