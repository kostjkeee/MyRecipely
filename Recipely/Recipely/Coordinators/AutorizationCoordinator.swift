// AutorizationCoordinator.swift

import UIKit

/// Авторизационный флоу приложения
final class AutorizationCoordinator: BaseCoodinator {
    // MARK: - Public Properties

    var rootController: UINavigationController?
    var onFinishFlow: VoidHandler?

    // MARK: - Private Properties

    private var moduleBuilder: Builder?

    // MARK: - Public Methods

    func setRootViewController(view: UIViewController, moduleBuilder: Builder) {
        rootController = UINavigationController(rootViewController: view)
        self.moduleBuilder = moduleBuilder
    }

    // MARK: - Public Methods

    func logIn() {
        onFinishFlow?()
    }
}
