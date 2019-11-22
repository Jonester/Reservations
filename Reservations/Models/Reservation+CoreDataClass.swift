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
        
        Reservation.resetIndex(in: context)
        guard let reservations = Reservation.fetchReservations(in: context) else { return nil }
        let filteredReservations = reservations.filter { $0.deletedAt == nil && $0.messageSentAt == nil }
        let reservation = Reservation(entity: entity, insertInto: context)
        reservation.name = name
        reservation.phoneNumber = phoneNumber
        reservation.partySize = partySize
        reservation.uuid = UUID().uuidString
        if filteredReservations.count == 0 {
            reservation.index = 0
        } else if filteredReservations.count == 1 {
            reservation.index = 1
        } else {
            reservation.index = Int16(filteredReservations.count)
        }
        
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
    
    static func fetchActiveReservations(in context: NSManagedObjectContext) -> [Reservation]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reservation")
        fetchRequest.predicate = NSPredicate(format: "index >= 0")
        do {
            guard let reservations = try context.fetch(fetchRequest) as? [Reservation] else { return nil }
            let filteredReservations = reservations.filter { $0.deletedAt == nil && $0.messageSentAt == nil }
            return filteredReservations.sorted { $0.index < $1.index }
        } catch {
            print(error)
            return nil
        }
    }
    
    static func resetIndex(in context: NSManagedObjectContext) {
        guard let reservations = Reservation.fetchActiveReservations(in: context) else { return }
        var count = 0
        reservations.forEach {
            $0.index = Int16(count)
            count += 1
        }
    }
}
