//
//  PlaceEntity+CoreDataProperties.swift
//  CoreDataUnitTestingExample
//
//  Created by Lucas Nascimento on 14/06/19.
//  Copyright © 2019 Lucas Nascimento. All rights reserved.
//
//

import Foundation
import CoreData

extension PlaceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlaceEntity> {
        return NSFetchRequest<PlaceEntity>(entityName: "Place")
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?

}
