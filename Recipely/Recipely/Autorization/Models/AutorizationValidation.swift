// AutorizationValidation.swift

import Foundation

/// Протокол валидации авторизации
protocol AutorizationValidationProtocol: AnyObject {
    /// Проверка валидации пароля
    func isValid(enteringEmail: String?, enteringPassword: String?) -> Bool
}

/// Модуль проверки введенных пользоватлем данных
final class AutorizationValidation: AutorizationValidationProtocol {
    // MARK: - Constants

    enum Constants {
        static let regexForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }

    // MARK: - Private Properties

    private let accountManager = StorageService<LoginPassword>(key: .loginPassword)

    // MARK: - Public method

    func isValid(enteringEmail: String?, enteringPassword: String?) -> Bool {
        let format = "SELF MATCHES %@"
        switch (enteringEmail, enteringPassword) {
        case (.some(let email), nil):
            return NSPredicate(format: format, Constants.regexForEmail).evaluate(with: email)
        case let (.some(email), .some(password)):
            if let loginPassword = accountManager.getContent() {
                return NSPredicate(format: format, Constants.regexForEmail).evaluate(with: email) &&
                    loginPassword.login == email && loginPassword.password == password
            } else {
                accountManager.setContent(LoginPassword(login: email, password: password))
                return true
            }
        default:
            return false
        }
    }
}
