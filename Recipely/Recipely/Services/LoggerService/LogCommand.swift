// LogCommand.swift

import Foundation

/// Комманд
final class LogCommand {
    // MARK: - Public Propeties

    var logMessage: String {
        switch action {
        case .openRecipe:
            return "Пользователь открыл “Экран рецептов”"
        case .openCatagoryOfRecipe:
            return "Пользовать перешел на ”Экран со списком рецептов из Рыбы”"
        case .openDetailsRecipe:
            return "Пользователь открыл ”Детали рецепта”"
        case .tapShareButton:
            return "Пользователь поделился рецептом"
        case .openFavorites:
            return "Пользователь открыл экран избранного"
        case .openProfile:
            return "Пользователь открыл экран пользователя"
        case .openPrivacy:
            return "Пользователь открыл экран политики конфидециальности"
        case .openBonuses:
            return "Пользователь открыл экран бонусов"
        case .openImagePicker:
            return "Пользователь открыл экран смены фото"
        case .openChangeNameAlert:
            return "Пользователь открыл форма изменения имени"
        case .openAutorization:
            return "Пользователь открыл экран авторизации"
        }
    }

    // MARK: - Private Methods

    private let action: LogActions

    // MARK: - Initializers

    init(action: LogActions) {
        self.action = action
    }
}
