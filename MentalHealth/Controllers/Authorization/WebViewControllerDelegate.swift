//
//  WebViewControllerDelegate.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
