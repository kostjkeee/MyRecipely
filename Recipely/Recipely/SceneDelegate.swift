// SceneDelegate.swift

import Swinject
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        createRootViewController(windowScene)
        Logger.logFileDate = Date()
    }

    private func createRootViewController(_ windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
        if let window {
            window.makeKeyAndVisible()
            let moduleBuilder = ModuleBuilder(container: setServicesInContainer())
            appCoordinator = AppCoordinator(appBuilder: moduleBuilder)
            appCoordinator?.start()
        }
    }

    private func setServicesInContainer() -> Container {
        let container = Swinject.Container()
        container.register(NetworkService.self) { _ in NetworkService() }
        container.register(LoggerService.self) { _ in LoggerService() }
        container
            .register(StorageService<LoginPassword>.self) { _ in StorageService<LoginPassword>(key: .loginPassword) }
        container.register(StorageService<UserInfo>.self) { _ in StorageService<UserInfo>(key: .userInfo) }
        container.register(FavoriteRecipesStorage.self) { _ in FavoriteRecipesStorage() }
        container.register(CoreDataStorageService.self) { _ in CoreDataStorageService.shared }
        container.register(CacheProxy.self) { _ in
            CacheProxy(
                networkService: container.resolve(NetworkService.self) ?? NetworkService(),
                coreDataStorageService: container.resolve(CoreDataStorageService.self) ?? CoreDataStorageService.shared
            )
        }
        return container
    }
}
