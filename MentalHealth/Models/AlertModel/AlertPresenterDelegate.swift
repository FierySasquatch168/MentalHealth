//
//  AlertPresenterDelegate.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func showAlert(alert: UIAlertController?)
}
