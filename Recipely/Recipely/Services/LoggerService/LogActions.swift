// LogActions.swift

import Foundation

/// Действия для записи логов
public enum LogActions {
    /// Открытие экрана рецептов
    case openRecipe
    /// Открытие экрана категорий рецептов
    case openCatagoryOfRecipe
    /// Открытие экрана деталей категорий рецептов
    case openDetailsRecipe
    /// Нажатие кнопки поделиться
    case tapShareButton
    /// Открылся экран рецептов
    case openFavorites
    /// Открыт экран пользователя
    case openProfile
    /// Открыт экран политики конфидециальности
    case openPrivacy
    /// Открыт экран бонусов
    case openBonuses
    /// Открыт экран смены фото
    case openImagePicker
    /// Открыта форма изменения имени
    case openChangeNameAlert
    /// Открыт экран авторизации
    case openAutorization
}
