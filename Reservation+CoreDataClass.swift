//
//  Reservation+CoreDataClass.swift
//  Reservations
//
//  Created by Chris Jones on 2019-11-21.
//  Copyright © 2019 Chris Jones. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Reservation)
public class Reservation: NSManagedObject {

    static func reservation(name: String, phoneNumber: String, partySize: Int16, context: NSManagedObjectContext) -> Reservation? {
        guard let entity = NSEntityDescription.entity(forEntityName: "Reservation", in: context) else { return nil }
        let reservation = Reservation(entity: entity, insertInto: context)
        reservation.name = name
        reservation.phoneNumber = phoneNumber
        reservation.partySize = partySize
        reservation.uuid = UUID().uuidString

        return reservation
    }

    static func fetchReservations(in context: NSManagedObjectContext) -> [Reservation]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reservation")
        do {
            guard let reservations = try context.fetch(fetchRequest) as? [Reservation] else { return nil }
            return reservations
        } catch {
            print(error)
            return nil
        }
    }
}
