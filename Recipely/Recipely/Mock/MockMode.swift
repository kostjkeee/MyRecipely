// MockMode.swift

import Foundation

/// Проверка мок мода
final class MockMode {
    /// Режим работы на моках вместо сервера
    static var isMockMode: Bool {
        #if Mock
        true
        #else
        false
        #endif
    }
}
