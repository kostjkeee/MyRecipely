// ViewState.swift

import Foundation

/// Состояния данных
enum ViewState<Model> {
    /// Загрузка
    case loading
    /// Есть данные
    case data(_ model: Model)
    /// Нет данных
    case noData(_ retryHandler: VoidHandler? = nil)
    /// Ошибка
    case error(_ error: Error, _ retryHandler: VoidHandler)
}
