//
//  Car+CoreDataProperties.swift
//  Registration
//
//  Created by Gleb Uvarkin on 13.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var name: String?
    @NSManaged public var toUser: User?

}
