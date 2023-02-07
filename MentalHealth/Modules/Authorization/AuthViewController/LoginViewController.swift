//
//  ViewController.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func loginViewController(_ vc: LoginViewController, didAuthenticateWithCode code: String)
}

class LoginViewController: UIViewController {
    
    weak var loginViewControllerDelegate: LoginViewControllerDelegate?

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
    
    private lazy var mainStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 60
        stackView.addArrangedSubview(yourselfLogo)
        stackView.addArrangedSubview(loginStackView)
        stackView.addArrangedSubview(startButton)
        return stackView
    }()
    
    private lazy var loginStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(registrationButton)
        return stackView
    }()
    
    private lazy var yourselfLogo: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "YourselfLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 138).isActive = true
        return imageView
    }()
    
    // MARK: LoginStackView
    
    private lazy var loginTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Log in"
        textField.textAlignment = .center
        textField.font = UIFont(name: CustomFont.kyivTypeSansRegular2.rawValue, size: 20)
        textField.backgroundColor = .customCVBackground
        textField.layer.cornerRadius = 31.5
        textField.widthAnchor.constraint(equalToConstant: 265).isActive = true
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Password"
        textField.textAlignment = .center
        textField.font = UIFont(name: CustomFont.kyivTypeSansRegular2.rawValue, size: 20)
        textField.backgroundColor = .customCVBackground
        textField.layer.cornerRadius = 31.5
        textField.widthAnchor.constraint(equalToConstant: 265).isActive = true

        return textField
    }()
    
    private lazy var registrationButton: UIButton = {
        var button = UIButton()
        button.setTitle("Registration", for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFont.InterLight.rawValue, size: 15)
        
        let title = NSAttributedString(string: "Registration", attributes: [
            NSAttributedString.Key.underlineStyle: 1.0,
            NSAttributedString.Key.font : UIFont(name: CustomFont.InterLight.rawValue, size: 15)
                ])
        
        button.setAttributedTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    private lazy var startButton: BottomActionButton = {
        var button = BottomActionButton(color: .customPurple ?? .black, title: "START")
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(self, action: #selector(goToWebVC), for: .touchUpInside)
        return button
    }()

    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//
//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names: \(names)")
//        }
        
        setupUI()
    }

    // MARK: WebViewViewControllerDelegate methods

    
    @objc private func goToWebVC() {
        let nextViewController = WebViewViewController()
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.authDelegate = self
        
        self.present(nextViewController, animated: true)
    }
    
    // MARK: UI setup
    
    private func setupUI() {
        setupBackGroundTopGradientImage()
        setupBackGroundBottomGradientImage()
        setupMainStackView()
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
    
    // MARK: StackView
    
    private func setupMainStackView() {
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 178),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 62),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -62),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -56)
        ])
    }
}

// MARK: Extensions

extension LoginViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        loginViewControllerDelegate?.loginViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

