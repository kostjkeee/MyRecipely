// CoreDataStorageService.swift

import CoreData
import Foundation

/// Протокол кор дата сервиса
protocol CoreDataStorageServiceProtocol {
    /// Создание рецепта в памяти
    func createRecipes(_ recipeCards: [RecipeCard], recipesCategory: String)
    /// Создание деталей рецепта
    func createRecipeDetails(_ recipeDetails: RecipeDetails, uri: String)
    /// Получение рецептов
    func fetchRecipes(_ category: String) -> [RecipeCard]
    /// Получение деталей рецепта
    func fetchRecipeDetails(_ uri: String) -> RecipeDetails?
    /// Обновление инофрмации о рецептах
    func updateRecipes(searchPhrase: String, newRecipes: [RecipeCard])
    /// Удаление всех рецептов
    func deleteAllRecipes()
}

/// Сервис для хранения в CoreData
final class CoreDataStorageService: CoreDataStorageServiceProtocol {
    // MARK: - Constants

    enum Constants {
        static let containerName = "CoreDataStorage"
        static let entityName = "StorageRecipesCard"
    }

    static let shared = CoreDataStorageService()

    // MARK: - Private Properties

    private var context: NSManagedObjectContext
    private var persistentContainer: NSPersistentContainer

    // MARK: - Initializers

    private init() {
        persistentContainer = {
            let container = NSPersistentContainer(name: Constants.containerName)
            container.loadPersistentStores { _, error in
                if let error = error as NSError? {
                    print(error)
                }
            }
            return container
        }()
        context = persistentContainer.viewContext
    }

    // MARK: - Public Methods

    func createRecipes(_ recipeCards: [RecipeCard], recipesCategory: String) {
        let storageRecipesCard = StorageRecipesCard(context: context)

        if let storageRecipeCards = getRecipes() {
            if storageRecipeCards.contains(where: { $0.objectName == recipesCategory }) {
                updateRecipes(searchPhrase: recipesCategory, newRecipes: recipeCards)
                return
            }
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(recipeCards) {
            storageRecipesCard.object = encoded
            storageRecipesCard.objectName = recipesCategory
            saveContext()
        }
    }

    func createRecipeDetails(_ recipeDetails: RecipeDetails, uri: String) {
        let storageRecipesCard = StorageRecipesCard(context: context)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(recipeDetails) {
            storageRecipesCard.object = encoded
            storageRecipesCard.objectName = uri
            saveContext()
        }
    }

    func fetchRecipes(_ category: String) -> [RecipeCard] {
        do {
            let decoder = JSONDecoder()
            guard let storageRecipeCards = getRecipes(),
                  let storageRecipeCard = storageRecipeCards.first(where: { $0.objectName == category })?
                  .object,
                  let recipeCards = try? decoder.decode([RecipeCard].self, from: storageRecipeCard) else { return [] }
            return recipeCards
        }
    }

    func fetchRecipeDetails(_ uri: String) -> RecipeDetails? {
        do {
            let decoder = JSONDecoder()
            guard let storageRecipeCards = getRecipes(),
                  let storageRecipeCard = storageRecipeCards.first(where: { $0.objectName == uri })?
                  .object,
                  let recipeCards = try? decoder.decode(RecipeDetails.self, from: storageRecipeCard) else { return nil }
            return recipeCards
        }
    }

    func updateRecipes(searchPhrase: String, newRecipes: [RecipeCard]) {
        guard let storageRecipeCards = getRecipes(),
              let storageRecipeCard = storageRecipeCards.first(where: { $0.objectName == searchPhrase })
        else { return }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(newRecipes) {
            storageRecipeCard.object = encoded
            saveContext()
        }
    }

    func deleteAllRecipes() {
        guard let storageRecipeCards = getRecipes() else { return }
        storageRecipeCards.forEach { context.delete($0) }
        saveContext()
    }

    // MARK: - Private Methods

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
            }
        }
    }

    private func getRecipes() -> [StorageRecipesCard]? {
        try? context
            .fetch(NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)) as? [StorageRecipesCard]
    }
}
