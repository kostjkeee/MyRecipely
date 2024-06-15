// StorageRecipesCard+CoreDataProperties.swift

import CoreData
import Foundation

/// Кеш рецептов для категорий
@objc(StorageRecipesCard)
final class StorageRecipesCard: NSManagedObject {}

extension StorageRecipesCard {
    @NSManaged var object: Data?
    @NSManaged var objectName: String?
}
