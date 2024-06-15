// RecipesCoordinator.swift

import UIKit

/// Протокол для открытия деталей о рецепте
protocol RecipesDetailCoordinatorProtocol: AnyObject {
    /// Открыть экран деталей
    func openRecipeDetails(recipeURI: String)
    /// Вернуться на экран рецептов
    func backToRecipes()
    /// Поделиться рецептом
    func shareRecipe(text: String)
}

/// Координатор флоу рецептов
final class RecipesCoordinator: BaseCoodinator {
    // MARK: - Public Properties

    var onFinishFlow: VoidHandler?
    var rootController: UINavigationController?

    // MARK: - Private Properties

    private var moduleBuilder: Builder?

    // MARK: - Public Methods

    func setRootViewController(view: UIViewController, moduleBuilder: Builder) {
        rootController = UINavigationController(rootViewController: view)
        self.moduleBuilder = moduleBuilder
    }

    func goToCategory(_ category: RecipeCategories) {
        rootController?.viewControllers.first?.hidesBottomBarWhenPushed = true
        let recepeCategoryView = moduleBuilder?.createRecepeCategoryModule(coordinator: self, category: category)
        recepeCategoryView?.navigationItem.title = category.rawValue
        rootController?.pushViewController(recepeCategoryView ?? UIViewController(), animated: true)
    }

    func backToCategiries() {
        rootController?.viewControllers.first?.hidesBottomBarWhenPushed = false
        rootController?.popViewController(animated: true)
    }
}

// MARK: - RecipesCoordinator + RecipesDetailCoordinatorProtocol

extension RecipesCoordinator: RecipesDetailCoordinatorProtocol {
    func backToRecipes() {
        if rootController?.viewControllers.first is FavoritesViewController {
            rootController?.viewControllers.first?.hidesBottomBarWhenPushed = false
        }
        rootController?.popViewController(animated: true)
    }

    func openRecipeDetails(recipeURI: String) {
        let recipeDetailView = moduleBuilder?.createRecipeDetailModule(coordinator: self, recipeURI: recipeURI)
        rootController?.pushViewController(recipeDetailView ?? UIViewController(), animated: true)
    }

    func shareRecipe(text: String) {
        let sharingView = moduleBuilder?.createSharingModule(sharingInfo: [text])
        rootController?.viewControllers.last?.present(sharingView ?? UIViewController(), animated: true)
    }
}
