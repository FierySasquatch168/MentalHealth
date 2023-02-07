//
//  MoodPickerModel.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

struct MoodPickerModel {
    let icon: UIImage
}

final class MoodModel {
    static var moods = [UIImage] (
        arrayLiteral: UIImage(named: "Happy") ?? UIImage(),
        UIImage(named: "Resentment") ?? UIImage())
}
