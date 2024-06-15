// LoginPassword.swift

import Foundation

/// Контейнер для логина и пароля
struct LoginPassword: Codable {
    /// Логин пользователя
    let login: String
    /// Пароль пользователя
    let password: String
}
