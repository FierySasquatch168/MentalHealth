//
//  UIViewController+Extension.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 09.02.2023.
//

import UIKit

class DiaryModuleViewController: UIViewController {
    
    let coreDataManager = CoreDataManager.shared
    
    func formNewNote() -> MoodNote {
        let newNote = MoodNote(context: self.coreDataManager.context)
        newNote.day = setTheDateForNote(with: "dd")
        newNote.month = setTheDateForNote(with: "LLL")
        newNote.time = setTheDateForNote(with: "HH:mm")

        return newNote
    }
    
    func setTheDateForNote(with dateFormat: String) -> String {
        let dateNow = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.string(from: dateNow)
        
        return date
    }
}
