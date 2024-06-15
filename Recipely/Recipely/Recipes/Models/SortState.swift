// SortState.swift

import Foundation

/// Состояние сортировки
enum SortState {
    /// От большего к меньшему
    case fromMostToLeast
    /// От меньшего к большему
    case fromLeastToMost
    /// Сортировка отключена
    case withoutSort
}
