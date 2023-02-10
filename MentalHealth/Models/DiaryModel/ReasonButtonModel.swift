//
//  ReasonButtonModel.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 08.02.2023.
//

import UIKit

struct ReasonButtonModel: Hashable, Identifiable {
    let id = UUID().uuidString
    let button: CustomReasonButton
    let imageName: String
    let buttonTitle: String
}
