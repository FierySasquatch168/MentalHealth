//
//  CoreDataManager.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 16.02.2023.
//

import UIKit
import CoreData

protocol CoreDataManagerDelegate: AnyObject {
    func updateTheNotes(with notes: [MoodNote])
}

protocol CoreDataManageable {
    var delegate: CoreDataManagerDelegate? { get set }
    func fetchNotesFromCoreData()
    func saveNotesToCoreData()
}

final class CoreDataManager: CoreDataManageable {
    static let shared = CoreDataManager()
    weak var delegate: CoreDataManagerDelegate?
    
    // reference to the managed context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: Core Data functionality
    
    func fetchNotesFromCoreData() {
        // Fetch the data from CoreData to display in the tableView
        do {
            let request = MoodNote.fetchRequest() as NSFetchRequest<MoodNote>
            
            // Set filtering and sorting on the request
            
            // TODO: Sorting by time works not right, needs more precise information about the time with seconds FIX!
            let timeSort = NSSortDescriptor(key: "time", ascending: false)
            let daySort = NSSortDescriptor(key: "day", ascending: false)
            let monthSort = NSSortDescriptor(key: "month", ascending: false)
            request.sortDescriptors = [monthSort, daySort, timeSort]
            
            // save the data to CoreData
            let updatedNotes = try context.fetch(request)
            delegate?.updateTheNotes(with: updatedNotes)
            
        } catch {
            // TODO: Show alert if saving is unseccsessfull
            print(error)
        }
    }
    
    func saveNotesToCoreData() {
        
        // Save the data
        do {
            try self.context.save()
            fetchNotesFromCoreData()
        } catch {
            print(error)
        }
    }
    
    
}
