// UserInfo.swift

import UIKit

/// Информация о пользователе
struct UserInfo: Codable {
    /// Имя и фамилия пользователя
    var nameSurname: String
    /// Название фото пользователя
    var userImageData: Data
    /// Количество бонусов
    var bonusesCount: Int

    init(
        nameSurname: String = "",
        userImageData: Data = UIImage(named: "userDefaultIcon")?.pngData() ?? Data(),
        bonusesCount: Int = 0
    ) {
        self.nameSurname = nameSurname
        self.userImageData = userImageData
        self.bonusesCount = bonusesCount
    }
}
