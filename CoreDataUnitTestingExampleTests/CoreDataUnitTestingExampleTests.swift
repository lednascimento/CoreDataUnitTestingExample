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
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
