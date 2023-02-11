//
//  SingleNoteViewController.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 11.02.2023.
//

import UIKit

class SingleNoteViewController: UIViewController {
    
    // MARK: To finish after design is ready
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .customTextField
        textField.layer.cornerRadius = 32
        textField.font = UIFont(name: CustomFont.kyivTypeSansRegular2.rawValue, size: 16)
        textField.contentVerticalAlignment = .top
        textField.contentHorizontalAlignment = .left
        return textField
    }()
    
    private lazy var mood: UILabel = {
        let textView = UILabel()
        textView.font = UIFont(name: CustomFont.kyivTypeSansRegular2.rawValue, size: 20)
        textView.text = "Mood: "
        return textView
    }()
    
    private lazy var timeandDate: UILabel = {
        let textView = UILabel()
        textView.text = "Time:"
        textView.font = UIFont(name: CustomFont.kyivTypeSansRegular2.rawValue, size: 20)
        return textView
    }()
    
    private lazy var reasons: UILabel = {
        let textView = UILabel()
        textView.text = "Reasons:"
        textView.font = UIFont(name: CustomFont.kyivTypeSansRegular2.rawValue, size: 20)
        return textView
    }()
    
    private lazy var cancelButton: BottomActionButton = {
        let button = BottomActionButton(color: .customPurple ?? .white, title: "Cancel")
        button.heightAnchor.constraint(equalToConstant: 61).isActive = true
        return button
    }()
    
    private lazy var textViewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(mood)
        stackView.addArrangedSubview(timeandDate)
        stackView.addArrangedSubview(reasons)
        return stackView
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

        setuptextField()
        setupTextViewStackView()
        setupButtonStack()
    }
    
    // MARK: setup UI
    
    private func setuptextField() {
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            textField.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTextViewStackView() {
        view.addSubview(textViewStackView)
        textViewStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textViewStackView.topAnchor.constraint(equalTo: textField.topAnchor, constant: 10),
            textViewStackView.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 10)
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
