//
//  AnalyticsProvider.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 13.03.2023.
//

import Foundation

protocol AnalyticsProviderProtocol {
    var notes: [MoodNote] { get }
    func fetchModelForAnalysis()
    func deliverModelForPresentation() -> [String]
    
}

final class AnalyticsProvider: AnalyticsProviderProtocol {
    var notes: [MoodNote] = []
    
    var dataConverter: DataConvertingProtocol
    var coreDataManager: CoreDataManageable
    
    init(dataConverter: DataConvertingProtocol, coreDataManager: CoreDataManageable) {
        self.dataConverter = dataConverter
        self.coreDataManager = coreDataManager
    }
    
    func fetchModelForAnalysis() {
        coreDataManager.delegate = self
        coreDataManager.fetchNotesFromCoreData()
    }
    
    func deliverModelForPresentation() -> [String] {
        return dataConverter.convertTheModelToData(from: notes)
    }
    
}

extension AnalyticsProvider: CoreDataManagerDelegate {
    func updateTheNotes(with notes: [MoodNote]) {
        self.notes = notes
    }
}
