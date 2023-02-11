//
//  Array+Extension.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

extension Array where Element == Article {
    func makeUnique(from array: inout Self, getRidOf: [Article]) {
        let indexRange = 0..<getRidOf.count
        var index = 0

        for _ in indexRange {
            array.removeAll(where: { $0 == getRidOf[index] })
            index += 1
        }

    }
}
