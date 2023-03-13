//
//  DataConverter.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 13.03.2023.
//

import Foundation

protocol DataConvertingProtocol {
    func convertTheModelToData(from array: [MoodNote]) -> [String]
}

struct DataConverter: DataConvertingProtocol {
    func convertTheModelToData(from array: [MoodNote]) -> [String] {
        // TODO: connect mood and chart and update reasons when user taps different chart parts
        let reasons = convertNotesToReasons(from: array, with: "Resentment")
        let reasonsDictionary = countMostPopularReasons(from: reasons)
        let sortedReasons = reasonsDictionary.sorted { $0.value > $1.value }.compactMap({ $0.key })
        
        return getTheFinalResult(from: sortedReasons)
    }
    
    
}

extension DataConverter {
    private func convertNotesToReasons(from notes: [MoodNote], with mood: String) -> [String] {
        var reasonsHappyFromFetchedModel: [String] = []
        for i in 0..<notes.count {
            if notes[i].moodDescription == mood, let reasonsDescription = notes[i].reasonsDescription {
                let stringArray: [String] = reasonsDescription.components(separatedBy: ", ")
                for x in 0..<stringArray.count {
                    reasonsHappyFromFetchedModel.append(stringArray[x])
                }
            }
        }
        return reasonsHappyFromFetchedModel
    }
    
    private func countMostPopularReasons(from array: [String]) -> [String: Int] {
        var mostPopularReasons: [String: Int] = [:]
        array.forEach { reason in
            mostPopularReasons[reason,default: 0] += 1
        }
        return mostPopularReasons
    }
    
    private func getTheFinalResult(from array: [String]) -> [String] {
        if array.count == 0 {
            return ["You did not add any reasons yet"]
        }
        
        if array.count > 1 {
            return array.dropLast(array.count - 2)
        } else {
            return array
        }
    }
}
