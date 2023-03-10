//
//  AlertPresenter.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

struct AlertPresenter: AlertPresenterProtocol {
    
    private weak var alertDelegate: AlertPresenterDelegate?
    
    init(alertDelegate: AlertPresenterDelegate) {
        self.alertDelegate = alertDelegate
    }
    
    func presentAlertController(alert: AlertModel) {
        let customAlert = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: .alert)
        
        customAlert.view.accessibilityIdentifier = "NetworkErrorAlert"
        
        let action = UIAlertAction(
            title: alert.buttonText,
            style: .cancel)
        
        customAlert.addAction(action)
        
        alertDelegate?.showAlert(alert: customAlert)
    }
    
    
}
