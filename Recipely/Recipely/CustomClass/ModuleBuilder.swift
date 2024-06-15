// ModuleBuilder.swift

import Swinject
import UIKit

/// Протокол билдера
protocol Builder {
    /// Функция создания модуля экрана авторизации
    func createAutorizationModule(coordinator: AutorizationCoordinator) -> UIViewController
    /// Функция создания модуля экрана с таб баром
    func createTabBarModule() -> UITabBarController
    /// Функция создания модуля экрана профиля
    func createProfileModule(coordinator: ProfileCoordinator) -> UIViewController
    /// Функция создания модуля экрана избранного
    func createFavoritesModule(coordinator: FavoritesCoordinator) -> UIViewController
    /// Функция создания модуля экрана рецептов
    func createRecipesModule(coordinator: RecipesCoordinator) -> UIViewController
    /// Функция создания модуля экрана бонусов
    func createBonusesProfileModule(coordinator: ProfileCoordinator) -> UIViewController
    /// Функция создания модуля блюд категории
    func createRecepeCategoryModule(coordinator: RecipesCoordinator, category: RecipeCategories) -> UIViewController
    /// Функция создания модуля деталей рецепта
    func createRecipeDetailModule(coordinator: RecipesDetailCoordinatorProtocol, recipeURI: String) -> UIViewController
    /// Функция создания контроллера шеринка
    func createSharingModule(sharingInfo: [Any]) -> UIViewController
}

/// Билдер модулей
final class ModuleBuilder: Builder {
    // MARK: - Private Methods

    let container: Container

    // MARK: - Initializers

    init(container: Container) {
        self.container = container
    }

    // MARK: - Public Methods

    func createAutorizationModule(coordinator: AutorizationCoordinator) -> UIViewController {
        let view = AutorizationViewController()
        let autorizationValidation = AutorizationValidation()
        let presenter = AutorizationPresenter(
            view: view,
            autorizationValidation: autorizationValidation,
            coordinator: coordinator,
            loggerService: container.resolve(LoggerService.self)
        )
        view.presenter = presenter
        return view
    }

    func createTabBarModule() -> UITabBarController {
        MainTabBarViewController()
    }

    func createProfileModule(coordinator: ProfileCoordinator) -> UIViewController {
        let view = ProfileViewController()
        let infoSource = InfoSource()
        let presenter = ProfilePresenter(
            view: view,
            infoSource: infoSource,
            coordinator: coordinator,
            loggerService: container.resolve(LoggerService.self),
            storageService: container.resolve(StorageService<UserInfo>.self)
        )
        view.presenter = presenter
        view.tabBarItem = UITabBarItem(
            title: Local.ModuleBuilder.titleProfile,
            image: UIImage(named: ImageName.profileIcon.rawValue),
            selectedImage: UIImage(named: ImageName.selectedProfileIcon.rawValue)
        )
        return view
    }

    func createBonusesProfileModule(coordinator: ProfileCoordinator) -> UIViewController {
        let view = ProfileBonusesViewController()
        let infoSource = InfoSource()
        let presenter = ProfileBonusesPresenter(view: view, infoSource: infoSource, coordinator: coordinator)
        view.presenter = presenter
        return view
    }

    func createRecipesModule(coordinator: RecipesCoordinator) -> UIViewController {
        let view = RecipesViewController()
        let presenter = RecipesPresenter(
            view: view,
            coordinator: coordinator,
            loggerService: container.resolve(LoggerService.self)
        )
        view.presenter = presenter
        view.tabBarItem = UITabBarItem(
            title: Local.ModuleBuilder.titleRecipes,
            image: UIImage(named: ImageName.recipesIcon.rawValue),
            selectedImage: UIImage(named: ImageName.selectedRecipesIcon.rawValue)
        )
        return view
    }

    func createRecepeCategoryModule(coordinator: RecipesCoordinator, category: RecipeCategories) -> UIViewController {
        let view = RecepeCategoryView()
        let presenter = RecepeCategoryPresenter(
            view: view,
            coordinator: coordinator,
            networkService: container.resolve(CacheProxy.self),
            category: category,
            loggerService: container.resolve(LoggerService.self)
        )
        view.presenter = presenter
        return view
    }

    func createFavoritesModule(coordinator: FavoritesCoordinator) -> UIViewController {
        let view = FavoritesViewController()
        let presenter = FavoritesPresenter(
            view: view,
            coordinator: coordinator,
            loggerService: container.resolve(LoggerService.self),
            favoriteRecipesStorage: container.resolve(FavoriteRecipesStorage.self)
        )
        view.presenter = presenter
        view.tabBarItem = UITabBarItem(
            title: Local.ModuleBuilder.titleFavorites,
            image: UIImage(named: ImageName.favoritesIcon.rawValue),
            selectedImage: UIImage(named: ImageName.selectedFavoriteIcon.rawValue)
        )
        return view
    }

    func createRecipeDetailModule(
        coordinator: RecipesDetailCoordinatorProtocol,
        recipeURI: String
    ) -> UIViewController {
        let view = RecipeDetailView()
        let presenter = RecipeDetailPresenter(
            view: view,
            coordinator: coordinator,
            recipeURI: recipeURI,
            networkService: container.resolve(CacheProxy.self),
            loggerService: container.resolve(LoggerService.self),
            favoriteRecipesStorage: container.resolve(FavoriteRecipesStorage.self)
        )
        view.presenter = presenter
        return view
    }

    func createSharingModule(sharingInfo: [Any]) -> UIViewController {
        UIActivityViewController(activityItems: sharingInfo, applicationActivities: nil)
    }
}
