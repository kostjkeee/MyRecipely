// AppCoordinator.swift

import UIKit

/// Главный координатор приложения
final class AppCoordinator: BaseCoodinator {
    // MARK: - Public Properties

    private var tabBarViewController: UITabBarController?
    private var appBuilder: Builder

    // MARK: - Public Methods

    override func start() {
        t​oAutorization()
    }

    // MARK: - Initializers

    init(appBuilder: Builder) {
        self.appBuilder = appBuilder
    }

    // MARK: - Private Methods

    private func toMain() {
        tabBarViewController = appBuilder.createTabBarModule()

        let recipesCoordinator = RecipesCoordinator()
        let recipesViewController = appBuilder.createRecipesModule(coordinator: recipesCoordinator)
        recipesCoordinator.setRootViewController(view: recipesViewController, moduleBuilder: appBuilder)
        add(coordinator: recipesCoordinator)

        let profileCoordinator = ProfileCoordinator()
        let profileViewController = appBuilder.createProfileModule(coordinator: profileCoordinator)
        profileCoordinator.setRootViewController(view: profileViewController, moduleBuilder: appBuilder)
        add(coordinator: profileCoordinator)

        let favoritesCoordinator = FavoritesCoordinator()
        let favoritesViewController = appBuilder.createFavoritesModule(coordinator: favoritesCoordinator)
        favoritesCoordinator.setRootViewController(view: favoritesViewController, moduleBuilder: appBuilder)
        add(coordinator: favoritesCoordinator)

        profileCoordinator.onFinishFlow = { [weak self] in
            self?.remove(coordinator: recipesCoordinator)
            self?.remove(coordinator: favoritesCoordinator)
            self?.remove(coordinator: profileCoordinator)
            self?.tabBarViewController = nil
            self?.t​oAutorization()
        }

        guard let profileView = profileCoordinator.rootController,
              let favoriteView = favoritesCoordinator.rootController,
              let recipesCoordinator = recipesCoordinator.rootController else { return }
        tabBarViewController?.setViewControllers([recipesCoordinator, favoriteView, profileView], animated: false)
        setAsRoot(tabBarViewController ?? UIViewController())

        let tabBarIdentifiers = [
            Local.RecipesTab.accessibilityIdentifier,
            Local.FavoritesTab.accessibilityIdentifier,
            Local.ProfileTab.accessibilityIdentifier
        ]

        if let tabItems = tabBarViewController?.tabBar.items {
            print(tabItems)
            for (index, item) in tabItems.enumerated() {
                item.accessibilityIdentifier = tabBarIdentifiers[index]
            }
        }
    }

    private func t​oAutorization() {
        let autorizationCoordinator = AutorizationCoordinator()
        let autorizationViewController = appBuilder.createAutorizationModule(coordinator: autorizationCoordinator)
        autorizationCoordinator.setRootViewController(view: autorizationViewController, moduleBuilder: appBuilder)
        add(coordinator: autorizationCoordinator)
        autorizationCoordinator.onFinishFlow = { [weak self] in
            self?.remove(coordinator: autorizationCoordinator)
            self?.toMain()
        }

        setAsRoot(autorizationCoordinator.rootController ?? UIViewController())
    }
}
