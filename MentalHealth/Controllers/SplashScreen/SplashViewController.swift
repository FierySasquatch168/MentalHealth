//
//  SplashViewController.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

class SplashViewController: UIViewController {

    private let oAuth2Service = OAuth2Service()
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    
    private var alertModel: AlertModel?
    private var alertPresenter: AlertPresenterProtocol?
    
    private lazy var splashViewLogo: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "YourselfLogo")
        
        return imageView
    }()
    
    private lazy var backgroundTopGradientImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "backgroundTopGradientImage")
        return imageView
    }()
    
    private lazy var backgroundBottomGradientImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "backgroundBottomGradientImage")
        return imageView
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let token = oAuth2TokenStorage.token {
            fetchProfile(token: token)
        } else {
            switchToLoginViewController()
        }
    }
    
    // MARK: PrivateFuncs
    
    private func switchToTabBarController() {
        let tabbarVC = MainTabBarViewController()
        tabbarVC.modalPresentationStyle = .fullScreen
        
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = tabbarVC
    }
    
    private func switchToLoginViewController() {
        let loginVC = LoginViewController()
        loginVC.loginViewControllerDelegate = self
        
        let navVC = UINavigationController(rootViewController: loginVC)
        navVC.modalPresentationStyle = .fullScreen
        
        self.present(navVC, animated: true)
    }
    
    // MARK: UI setup
    
    private func setupUI() {
        setupBackGroundTopGradientImage()
        setupBackGroundBottomGradientImage()
        setupLogo()
    }
    
    // MARK: Background
    
    private func setupBackGroundTopGradientImage() {
        view.addSubview(backgroundTopGradientImage)
        backgroundTopGradientImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundTopGradientImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundTopGradientImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundTopGradientImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupBackGroundBottomGradientImage() {
        view.addSubview(backgroundBottomGradientImage)
        backgroundBottomGradientImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundBottomGradientImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundBottomGradientImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundBottomGradientImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupLogo() {
        view.addSubview(splashViewLogo)
        splashViewLogo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            splashViewLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashViewLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: Extensions

extension SplashViewController: LoginViewControllerDelegate {
    func loginViewController(_ vc: LoginViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code: code)
        }
        
    }
    
    private func fetchOAuthToken(code: String) {
        oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure(let error):
                self.showAuthErrorAlert()
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token: token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case . success(let profile):
                self.switchToTabBarController()
            case .failure(let error):
                self.showAuthErrorAlert()
            }
        }
    }
    
    
}

extension SplashViewController: AlertPresenterDelegate {
    func showAlert(alert: UIAlertController?) {
        guard let alert = alert else { return }
        self.present(alert, animated: true)
    }
    
    func showAuthErrorAlert() {
        
        let alert = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            buttonText: "OK")
        
        alertPresenter = AlertPresenter(alertDelegate: self)
        alertPresenter?.presentAlertController(alert: alert)
        
    }
    
}
