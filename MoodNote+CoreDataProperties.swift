//
//  MoodNote+CoreDataProperties.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//
//

import UIKit
import CoreData


extension MoodNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoodNote> {
        return NSFetchRequest<MoodNote>(entityName: "MoodNote")
    }

    @NSManaged public var backgroundImage: UIImage?
    @NSManaged public var day: String?
    @NSManaged public var month: String?
    @NSManaged public var mood: UIImage?
    @NSManaged public var moodDescription: String?
    @NSManaged public var reasonsDescription: String?
    @NSManaged public var time: String?

}

extension MoodNote : Identifiable {

}
