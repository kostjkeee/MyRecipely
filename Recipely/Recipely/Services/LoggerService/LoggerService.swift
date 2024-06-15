// LoggerService.swift

import Foundation

/// Функция для вызова добавления в Лог
protocol LoggerServiceProtocol {
    func log(_ action: LogActions)
}

/// Логер Менеджер
final class LoggerService: LoggerServiceProtocol {
    func log(_ action: LogActions) {
        let command = LogCommand(action: action)
        LoggerInvoker.shared.addLogCommand(command)
    }
}
