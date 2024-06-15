// ProfilePresenter.swift

import Foundation

/// Протокол презентера экрана профиля
protocol ProfileViewPresenterProtocol: AnyObject {
    /// Инициализатор с присвоением вью источника данных
    init(
        view: ProfileViewProtocol,
        infoSource: InfoSourceProtocol,
        coordinator: ProfileCoordinator,
        loggerService: LoggerServiceProtocol?,
        storageService: StorageService<UserInfo>?
    )
    /// Получение информации о пользователе
    func getUserInformation() -> ViewState<UserInfo>
    /// Выход из аккаунта
    func logOut()
    /// Обработка нажатия кнопки Log out
    func logOutAction()
    /// Показ экрана с фонусами
    func showBonuses()
    /// Обработка нажатия кнопки изменения имени
    func actionChangeName()
    /// Обработка нажатия кнопки изменения фото
    func actionChangePhoto(imageData: Data)
    /// Изменение имени пользователя
    func editNameSurname(name: String)
    /// Открытие информации о приватности
    func openPrivacyInfo()
    /// Добавление логов
    func sendLog()
}

/// Презентер экрана профиля
final class ProfilePresenter: ProfileViewPresenterProtocol {
    // MARK: - Public Properties

    private weak var coordinator: ProfileCoordinator?
    private weak var view: ProfileViewProtocol?
    private var infoSource: InfoSourceProtocol?
    private var state: ViewState<UserInfo>
    private var loggerService: LoggerServiceProtocol?
    private var storageService: StorageService<UserInfo>?

    // MARK: - Initializers

    required init(
        view: ProfileViewProtocol,
        infoSource: InfoSourceProtocol,
        coordinator: ProfileCoordinator,
        loggerService: LoggerServiceProtocol?,
        storageService: StorageService<UserInfo>?
    ) {
        self.view = view
        self.infoSource = infoSource
        self.coordinator = coordinator
        self.loggerService = loggerService
        self.storageService = storageService
        if storageService?.getContent() == nil {
            storageService?.setContent(UserInfo())
        }
        state = .data(storageService?.getContent() ?? UserInfo(nameSurname: "error"))
    }

    // MARK: - Public Methods

    func getUserInformation() -> ViewState<UserInfo> {
        guard let userInfo = storageService?.getContent() else {
            state = .noData(nil)
            return state
        }
        state = .data(userInfo)
        return state
    }

    func logOutAction() {
        view?.showLogOutAlert()
    }

    func logOut() {
        coordinator?.logOut()
    }

    func showBonuses() {
        coordinator?.showBonuses()
        loggerService?.log(.openBonuses)
    }

    func actionChangeName() {
        view?.showChangeNameAlert()
        loggerService?.log(.openChangeNameAlert)
    }

    let imagePicker = ImagePicker()
    func actionChangePhoto(imageData: Data) {
        guard var userInfo = storageService?.getContent() else { return }
        userInfo.userImageData = imageData
        storageService?.setContent(userInfo)
        view?.setNewNameFromSource()
        loggerService?.log(.openImagePicker)
    }

    func editNameSurname(name: String) {
        guard var userInfo = storageService?.getContent() else { return }
        userInfo.nameSurname = name
        storageService?.setContent(userInfo)
        view?.setNewNameFromSource()
    }

    func openPrivacyInfo() {
        view?.showPrivacyCard(privacyText: infoSource?.privacyText ?? "error")
        loggerService?.log(.openPrivacy)
    }

    func sendLog() {
        loggerService?.log(.openProfile)
    }
}
