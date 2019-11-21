//
//  Settings+CoreDataClass.swift
//  Reservations
//
//  Created by Chris Jones on 2019-11-21.
//  Copyright © 2019 Chris Jones. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Settings)
public class Settings: NSManagedObject {

    static func settings(message: String, context: NSManagedObjectContext) -> Settings? {
        guard let entity = NSEntityDescription.entity(forEntityName: "Settings", in: context) else { return nil }
        let settings = Settings(entity: entity, insertInto: context)
        settings.message = message
        settings.uuid = UUID().uuidString

        return settings
    }

    static func fetchReservations(in context: NSManagedObjectContext) -> [Settings]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        do {
            guard let settings = try context.fetch(fetchRequest) as? [Settings] else { return nil }
            return settings
        } catch {
            print(error)
            return nil
        }
    }
}
