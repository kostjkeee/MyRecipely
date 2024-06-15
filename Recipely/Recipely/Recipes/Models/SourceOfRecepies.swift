// SourceOfRecepies.swift

import Foundation

/// Источник данных для рецептов
struct SourceOfRecepies {
    // MARK: - Public Properties

    var recipesToShow: [RecipeCard] = []
    var allRecipes: [RecipeCard] = []

    // MARK: - Private Properties

    private var searchedRecipes: [RecipeCard] = []

    // MARK: - Public Methods

    mutating func setRecipes(recipes: [RecipeCard], selectedSortMap: [SortTypes: SortState], isSerching: Bool) {
        if isSerching {
            searchedRecipes = recipes
        } else {
            allRecipes = recipes
        }
        setNeededInformation(selectedSortMap: selectedSortMap, isSerching: isSerching)
    }

    mutating func setNeededInformation(selectedSortMap: [SortTypes: SortState], isSerching: Bool) {
        let recipesForSort = isSerching ? searchedRecipes : allRecipes
        switch (selectedSortMap[.calories], selectedSortMap[.time]) {
        case (.fromMostToLeast, .withoutSort):
            recipesToShow = recipesForSort.sorted { $0.calories > $1.calories }
        case (.fromLeastToMost, .withoutSort):
            recipesToShow = recipesForSort.sorted { $0.calories < $1.calories }
        case (.withoutSort, .fromMostToLeast):
            recipesToShow = recipesForSort.sorted { $0.totalTime > $1.totalTime }
        case (.withoutSort, .fromLeastToMost):
            recipesToShow = recipesForSort.sorted { $0.totalTime < $1.totalTime }
        case (.withoutSort, .withoutSort):
            recipesToShow = recipesForSort.sorted { $0.label < $1.label }
        case (.fromMostToLeast, .fromMostToLeast):
            recipesToShow = recipesForSort
                .sorted { $0.totalTime > $1.totalTime }
                .sorted { $0.totalTime != $1.totalTime ? false : $0.calories > $1.calories }
        case (.fromLeastToMost, .fromMostToLeast):
            recipesToShow = recipesForSort
                .sorted { $0.totalTime > $1.totalTime }
                .sorted { $0.totalTime != $1.totalTime ? false : $0.calories < $1.calories }
        case (.fromMostToLeast, .fromLeastToMost):
            recipesToShow = recipesForSort
                .sorted { $0.totalTime < $1.totalTime }
                .sorted { $0.totalTime != $1.totalTime ? false : $0.calories > $1.calories }
        case (.fromLeastToMost, .fromLeastToMost):
            recipesToShow = recipesForSort
                .sorted { $0.totalTime < $1.totalTime }
                .sorted { $0.totalTime != $1.totalTime ? false : $0.calories < $1.calories }
        default:
            break
        }
    }
}
