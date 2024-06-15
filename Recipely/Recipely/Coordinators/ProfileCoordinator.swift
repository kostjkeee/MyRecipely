// ProfileCoordinator.swift

import UIKit

/// Координатор флоу профиля
final class ProfileCoordinator: BaseCoodinator {
    // MARK: - Public Properties

    var rootController: UINavigationController?
    var onFinishFlow: VoidHandler?
    var dismissBonuses: VoidHandler?

    // MARK: - Private Properties

    private var moduleBuilder: Builder?

    // MARK: - Public Methods

    func setRootViewController(view: UIViewController, moduleBuilder: Builder) {
        rootController = UINavigationController(rootViewController: view)
        self.moduleBuilder = moduleBuilder
    }

    func logOut() {
        onFinishFlow?()
    }

    func showBonuses() {
        let profileBonusesView = moduleBuilder?.createBonusesProfileModule(coordinator: self)
        profileBonusesView?.view.accessibilityIdentifier = Local.Profile.BonusesView.accessibilityIdentifier
        if let sheet = profileBonusesView?.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 30
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.prefersEdgeAttachedInCompactHeight = true
        }
        dismissBonuses = {
            profileBonusesView?.dismiss(animated: true)
        }
        rootController?.present(profileBonusesView ?? UIViewController(), animated: true)
    }
}
