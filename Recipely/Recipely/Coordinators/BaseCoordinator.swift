// BaseCoordinator.swift

import UIKit

/// Базовый координатор
class BaseCoodinator {
    // MARK: - Public Properties

    var childCoordinators: [BaseCoodinator] = []

    // MARK: - Public Methods

    func start() {
        fatalError("child должен быть реализован")
    }

    func add(coordinator: BaseCoodinator) {
        childCoordinators.append(coordinator)
    }

    func remove(coordinator: BaseCoodinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }

    func setAsRoot(_ controller: UIViewController) {
        let window = UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .last { $0.isKeyWindow }
        window?.rootViewController = controller
    }
}
