// InfoSource.swift

import Foundation
import UIKit

/// Протокол источника информации
protocol InfoSourceProtocol: AnyObject {
    /// Передача информации о пользователе
    func getUserInfo() -> UserInfo
    /// Изменение имени пользователя
    func changeUserName(nameSurname: String)
    /// Получение информации о количестве бонусов
    func getBonusesCount() -> Int
    /// Текст политики конфидициальности
    var privacyText: String { get set }
}

/// Источник информации
final class InfoSource: InfoSourceProtocol {
    var privacyText = """
    Welcome to our recipe app! We're thrilled to have you on board.
    To ensure a delightful experience for everyone, please take a moment to familiarize yourself with our rules:
    User Accounts:
     • Maintain one account per user.
     • Safeguard your login credentials; don't share them with others.
    Content Usage:
     • Recipes and content are for personal use only.
     • Do not redistribute or republish recipes without proper attribution.
    Respect Copyright:
     • Honor the copyright of recipe authors and contributors.
     • Credit the original source when adapting or modifying a recipe.
    Community Guidelines:
     • Show respect in community features.
     • Avoid offensive language or content that violates community standards.
    Feedback and Reviews:
     • Share constructive feedback and reviews.
     • Do not submit false or misleading information.
    Data Privacy:
     • Review and understand our privacy policy regarding data collection and usage.
    Compliance with Laws:
     • Use the app in compliance with all applicable laws and regulations.
    Updates to Terms:
     •Stay informed about updates; we'll notify you of any changes.
    By using our recipe app, you agree to adhere to these rules.
    Thank you for being a part of our culinary community! Enjoy exploring and cooking up a storm!
    """

    private let imageData = UIImage(named: "voznyak")?.pngData() ?? Data()
    // Информация о пользователе
    private lazy var personInfo: UserInfo = .init(
        nameSurname: "Steve Wozniak",
        userImageData: imageData,
        bonusesCount: 200
    )

    func getUserInfo() -> UserInfo {
        personInfo
    }

    func changeUserName(nameSurname: String) {
        personInfo.nameSurname = nameSurname
    }

    func getBonusesCount() -> Int {
        personInfo.bonusesCount
    }
}
