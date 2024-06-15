// ProfileBonusesPresenter.swift

import Foundation

/// Протокол презентера экрана бонусов
protocol ProfileBonusesViewPresenterProtocol: AnyObject {
    /// Инициализатор с присвоением вью источника данных
    init(view: ProfileBonusesViewProtocol, infoSource: InfoSourceProtocol, coordinator: ProfileCoordinator)
    /// Функция закрытия экрана бонусов
    func close()
}

/// Презентер экрана бонусов
final class ProfileBonusesPresenter: ProfileBonusesViewPresenterProtocol {
    // MARK: - Private Properties

    private weak var coordinator: ProfileCoordinator?
    private weak var view: ProfileBonusesViewProtocol?
    private var infoSource: InfoSourceProtocol

    // MARK: - Initializers

    required init(view: ProfileBonusesViewProtocol, infoSource: InfoSourceProtocol, coordinator: ProfileCoordinator) {
        self.view = view
        self.infoSource = infoSource
        self.coordinator = coordinator
        setBonusesCount()
    }

    // MARK: - Private Methods

    private func setBonusesCount() {
        view?.setBonuses(bonusesCount: infoSource.getBonusesCount())
    }

    func close() {
        coordinator?.dismissBonuses?()
    }
}
