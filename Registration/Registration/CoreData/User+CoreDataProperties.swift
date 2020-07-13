//
//  User+CoreDataProperties.swift
//  Registration
//
//  Created by Gleb Uvarkin on 13.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var password: String?
    @NSManaged public var login: String?
    @NSManaged public var surName: String?
    @NSManaged public var name: String?
    @NSManaged public var toCar: NSSet?

}

// MARK: Generated accessors for toCar
extension User {

    @objc(addToCarObject:)
    @NSManaged public func addToToCar(_ value: Car)

    @objc(removeToCarObject:)
    @NSManaged public func removeFromToCar(_ value: Car)

    @objc(addToCar:)
    @NSManaged public func addToToCar(_ values: NSSet)

    @objc(removeToCar:)
    @NSManaged public func removeFromToCar(_ values: NSSet)

}
