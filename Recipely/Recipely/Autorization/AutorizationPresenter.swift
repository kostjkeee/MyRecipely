// AutorizationPresenter.swift

import Foundation

/// Протокол презентера экрана авторизации
protocol AutorizationViewPresenterProtocol: AnyObject {
    /// Инициализатор с присвоением вью
    init(
        view: AutorizationViewProtocol,
        autorizationValidation: AutorizationValidationProtocol,
        coordinator: AutorizationCoordinator,
        loggerService: LoggerServiceProtocol?
    )
    /// Проверка валидации пароля
    func isValid(enteringEmail: String?, enteringPassword: String?) -> Bool?
    /// Функция изменения состояния видимости пароля
    func changePasswordVisableState()
    /// Переход на главный экран приложения
    func goToMainView()
    /// Добавление логов
    func sendLog()
}

/// Презентер экрана авторизации
final class AutorizationPresenter: AutorizationViewPresenterProtocol {
    // MARK: - Private Properties

    private var autorizationValidation: AutorizationValidationProtocol?
    private weak var coordinator: AutorizationCoordinator?
    private weak var view: AutorizationViewProtocol?
    private var loggerService: LoggerServiceProtocol?
    private var isPasswordVisible = false

    // MARK: - Initializers

    required init(
        view: AutorizationViewProtocol,
        autorizationValidation: AutorizationValidationProtocol,
        coordinator: AutorizationCoordinator,
        loggerService: LoggerServiceProtocol?
    ) {
        self.view = view
        self.coordinator = coordinator
        self.autorizationValidation = autorizationValidation
        self.loggerService = loggerService
    }

    // MARK: - Public method

    func isValid(enteringEmail: String?, enteringPassword: String?) -> Bool? {
        autorizationValidation?.isValid(enteringEmail: enteringEmail, enteringPassword: enteringPassword)
    }

    func changePasswordVisableState() {
        isPasswordVisible = !isPasswordVisible
        view?.changePasswordvisableState(isVisable: isPasswordVisible)
    }

    func goToMainView() {
        coordinator?.logIn()
    }

    func sendLog() {
        loggerService?.log(.openAutorization)
    }
}
