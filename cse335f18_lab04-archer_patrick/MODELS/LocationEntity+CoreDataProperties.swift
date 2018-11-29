//
//  LocationEntity+CoreDataProperties.swift
//  cse335f18_lab04-archer_patrick
//
//  Created by Patrick Archer on 10/21/18.
//  Copyright © 2018 Patrick Archer - Self. All rights reserved.
//
//

import Foundation
import CoreData


extension LocationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationEntity> {
        return NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
    }

    @NSManaged public var cdName: String?
    @NSManaged public var cdDescription: String?
    @NSManaged public var cdImage: NSData?

}
