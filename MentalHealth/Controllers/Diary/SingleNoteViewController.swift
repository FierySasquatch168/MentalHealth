//
//  SingleNoteViewController.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 11.02.2023.
//

import UIKit

class SingleNoteViewController: UIViewController {
    
    // MARK: To finish after design is ready
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .customTextField
        view.layer.cornerRadius = 32
        return view
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = true
        textView.isEditable = true
        textView.font = UIFont(name: CustomFont.kyivTypeSansRegular2.rawValue, size: 16)
        return textView
    }()
    
    private lazy var cancelButton: BottomActionButton = {
        let button = BottomActionButton(color: .customPurple ?? .white, title: "Cancel")
        button.heightAnchor.constraint(equalToConstant: 61).isActive = true
        return button
    }()
    
    private lazy var saveButton: BottomActionButton = {
        let button = BottomActionButton(color: .customPurple ?? .white, title: "Save")
        button.heightAnchor.constraint(equalToConstant: 61).isActive = true
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 17
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(saveButton)
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackgroundView()
        setupButtonStack()
    }
    
    // MARK: setup UI
    
    private func setupBackgroundView() {
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        backgroundView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
    }
    
    private func setupButtonStack() {
        view.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35)
        ])
    }

}
