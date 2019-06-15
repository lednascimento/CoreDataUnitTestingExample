//
//  CoreDataUnitTestingExampleTests.swift
//  CoreDataUnitTestingExampleTests
//
//  Created by Lucas Nascimento on 14/06/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//

import XCTest
import CoreData
@testable import CoreDataUnitTestingExample

class CoreDataUnitTestingExampleTests: XCTestCase {

    var storageManager: StorageManager?

    var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()

    lazy var mockPersistantContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "CoreDataUnitTestingExample", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in

            precondition(description.type == NSInMemoryStoreType)

            if let error = error {
                fatalError("In memory coordinator creation failed \(error)")
            }
        }
        return container
    }()

    override func setUp() {
        super.setUp()
        storageManager = StorageManager(container: mockPersistantContainer)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCheckEmpty() {
        if let storageManager = storageManager {
            let rows = storageManager.fetchAll()
            XCTAssertEqual(rows.count, 0)
        } else {
            XCTFail()
        }
    }

    func testInsert() {

        guard let storageManager = storageManager else {
            XCTFail()
            return
        }

        let rowsBefore = storageManager.fetchAll()
        XCTAssertEqual(rowsBefore.count, 0)

        for i in 1...10 {
            XCTAssertNotNil(storageManager.insertPlace(city: "City \(i)", country: "Country \(i)"))
        }

        storageManager.save()

        let rowsAfter = storageManager.fetchAll()
        XCTAssertEqual(rowsAfter.count, 10)
    }

    func testQuery() {
        guard let storageManager = self.storageManager else {
            XCTFail()
            return
        }

        let rowsBefore = storageManager.fetchAll()
        XCTAssertEqual(rowsBefore.count, 0)

        XCTAssertNotNil(storageManager.insertPlace(city: "London", country: "UK"))
        XCTAssertNotNil(storageManager.insertPlace(city: "Paris", country: "France"))
        XCTAssertNotNil(storageManager.insertPlace(city: "New York", country: "USA"))
        XCTAssertNotNil(storageManager.insertPlace(city: "Chicago", country: "USA"))
        XCTAssertNotNil(storageManager.insertPlace(city: "Tokyo", country: "Japan"))
        XCTAssertNotNil(storageManager.insertPlace(city: "Ann Arbor", country: "USA"))
        XCTAssertNotNil(storageManager.insertPlace(city: "Bristol", country: "UK"))
        XCTAssertNotNil(storageManager.insertPlace(city: "Rome", country: "Italy"))
        XCTAssertNotNil(storageManager.insertPlace(city: "London", country: "Canada"))
        XCTAssertNotNil(storageManager.insertPlace(city: "Lisbon", country: "Spain"))
        XCTAssertNotNil(storageManager.insertPlace(city: "Beijing", country: "China"))

        storageManager.save()


        var rows = storageManager.fetch(country: "USA")
        XCTAssertEqual(rows.count, 3)

        rows = storageManager.fetch(country: "Spain")
        XCTAssertEqual(rows.count, 1)

        rows = storageManager.fetch(city: "London")
        XCTAssertEqual(rows.count, 2)       // test correct number of rows
        XCTAssertEqual(rows[0].country, "Canada") // test country sort order
    }

    func testPerformanceExample() {
        guard let storageManager = self.storageManager else {
            XCTFail()
            return
        }

        self.measure {
            for i in 1...1000 {
                XCTAssertNotNil(storageManager.insertPlace(city: "City \(i)", country: "Country \(i)"))
            }
            storageManager.save()
        }
    }
}
