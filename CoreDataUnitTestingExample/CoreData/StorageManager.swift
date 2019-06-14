//
//  StorageManager.swift
//  CoreDataUnitTestingExample
//
//  Created by Lucas Nascimento on 14/06/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import CoreData
import UIKit

public class StorageManager {

    private let persistentContainer: NSPersistentContainer

    public init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    public convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate unavailable")
        }
        self.init(container: appDelegate.persistentContainer)
    }

    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()

    // MARK: CRUD

    @discardableResult public func insertPlace(city: String, country: String) -> PlaceEntity? {

        guard let place = NSEntityDescription.insertNewObject(forEntityName: "Place", into: backgroundContext) as? PlaceEntity else {
            return nil
        }

        place.city = city
        place.country = country
        return place
    }

    public func fetchAll(sorted: Bool = true) -> [PlaceEntity] {

        let request: NSFetchRequest<PlaceEntity> = PlaceEntity.fetchRequest()

        if sorted {
            let countrySort = NSSortDescriptor(key: #keyPath(PlaceEntity.country), ascending: true)
            let citySort = NSSortDescriptor(key: #keyPath(PlaceEntity.city), ascending: true)
            request.sortDescriptors = [countrySort, citySort]
        }

        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [PlaceEntity]()
    }

    public func fetch(city: String) -> [PlaceEntity] {

        let citySort = NSSortDescriptor(key: #keyPath(PlaceEntity.city), ascending: true)

        let request: NSFetchRequest<PlaceEntity> = PlaceEntity.fetchRequest()
        request.predicate = NSPredicate(format: "city == %@", city)
        request.sortDescriptors = [citySort]

        let results = try? persistentContainer.viewContext.fetch(request)

        return results ?? [PlaceEntity]()
    }

    public func fetch(country: String) -> [PlaceEntity] {

        let countrySort = NSSortDescriptor(key: #keyPath(PlaceEntity.country), ascending: true)

        let request: NSFetchRequest<PlaceEntity> = PlaceEntity.fetchRequest()
        request.predicate = NSPredicate(format: "country == %@", country)
        request.sortDescriptors = [countrySort]

        let results = try? persistentContainer.viewContext.fetch(request)

        return results ?? [PlaceEntity]()
    }

    public func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Save error \(error)")
            }
        }
    }
}
