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

        //hackey fix for demo
        guard let settings = Settings.fetchSettings(in: context) else { return nil }
        for setting in settings {
            context.delete(setting)
        }
        do {
            try context.save()
        } catch {
            print("error")
        }

        guard let entity = NSEntityDescription.entity(forEntityName: "Settings", in: context) else { return nil }
        let newSettings = Settings(entity: entity, insertInto: context)
        newSettings.message = message
        newSettings.uuid = UUID().uuidString

        return newSettings
    }

    static func fetchSettings(in context: NSManagedObjectContext) -> [Settings]? {
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
