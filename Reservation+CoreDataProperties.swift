//
//  Reservation+CoreDataProperties.swift
//  Reservations
//
//  Created by Chris Jones on 2019-11-21.
//  Copyright © 2019 Chris Jones. All rights reserved.
//
//

import Foundation
import CoreData


extension Reservation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reservation> {
        return NSFetchRequest<Reservation>(entityName: "Reservation")
    }

    @NSManaged public var name: String
    @NSManaged public var partySize: Int16
    @NSManaged public var phoneNumber: String
    @NSManaged public var index: Int16
    @NSManaged public var uuid: String
    @NSManaged public var deletedAt: Date?

}
