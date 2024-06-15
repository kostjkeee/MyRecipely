// FavoritesCoordinator.swift

import UIKit

/// Координатор флоу избранного
final class FavoritesCoordinator: BaseCoodinator {
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
}

// MARK: - RecipesCoordinator + RecipesDetailCoordinatorProtocol

extension FavoritesCoordinator: RecipesDetailCoordinatorProtocol {
    func backToRecipes() {
        rootController?.viewControllers.first?.hidesBottomBarWhenPushed = false
        rootController?.popViewController(animated: true)
    }

    func openRecipeDetails(recipeURI: String) {
        let recipeDetailView = moduleBuilder?.createRecipeDetailModule(coordinator: self, recipeURI: recipeURI)
        rootController?.viewControllers.first?.hidesBottomBarWhenPushed = true
        rootController?.pushViewController(recipeDetailView ?? UIViewController(), animated: true)
    }

    func shareRecipe(text: String) {
        let sharingView = moduleBuilder?.createSharingModule(sharingInfo: [text])
        rootController?.viewControllers.last?.present(sharingView ?? UIViewController(), animated: true)
    }
}
