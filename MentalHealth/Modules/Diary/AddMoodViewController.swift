//
//  AddMoodViewController.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

class AddMoodViewController: UIViewController, ReasonsUpdateDelegate, UpdatingDataControllerProtocol {
    
    // Reference to managed context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var updatingData: [MoodNote] = []
    var mood: UIImage?
    var backgroundImage: UIImage?
    var moodDescription: String?
    
    private let moodBackgroundChoice = ["Happy":"Rectangle 15", "Resentment":"Rectangle 14"]
    var handleUpdatedDataDelegate: DataUpdateDelegate?
    
    private lazy var howDoYouFeelLabel: UILabel = {
        var label = UILabel()
        
        return label
    }()
    
    private lazy var swipeUpOrDownLabel: UILabel = {
        var label = UILabel()
        
        return label
    }()
    
    private lazy var pickerView: UIPickerView = {
        var pickerView = UIPickerView()
        
        return pickerView
    }()
    
    private lazy var moodPickerModels: [MoodPickerModel] = {
        var models: [MoodPickerModel] = []
        
        for value in MoodModel.moods {
            models.append(.init(icon: value))
        }
        
        return models
    }()
    
    private lazy var moodLabel: UILabel = {
        var label = UILabel()
        
        return label
    }()
    
    // MARK: Stackview properties
    
    private lazy var middleStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        
        
        return stackView
    }()
    
    private lazy var bottomButtonStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 17
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(addButton)
        stackView.addArrangedSubview(saveButton)
        
        return stackView
    }()
    
    // MARK: Buttons
    
    private lazy var addButton: BottomActionButton = {
        var button = BottomActionButton(color: .customPurple ?? .black, title: "Add")
        button.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        return button
    }()
    
    private lazy var saveButton: BottomActionButton = {
        var button = BottomActionButton(color: .customPurple ?? .black, title: "Save")
        button.heightAnchor.constraint(equalToConstant: 61).isActive = true
        button.addTarget(self, action: #selector(saveNoteWithoutDetails), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var dismissButton: UIButton = {
        var button = UIButton()
        let image = UIImage(systemName: "xmark")
        image?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(dismissToRoot), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    // MARK: BackgroundGradient properties
    
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
        pickerViewSetup()
        moodLabel.text = "Happy"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // saving note through delegate from the moodBoardVC
    func saveNote(data: MoodNote) {
        // handle data to delegate
        handleUpdatedDataDelegate?.onDataUpdate(data: data)
        
        // pop to root VC
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func dismissToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func addNote() {
        
        
        // make data for transfering
        guard let moodLabelText = moodLabel.text,
              let moodImage = UIImage(named: moodLabelText),
              let actualBackgroundImage = UIImage(named: moodBackgroundChoice[moodLabelText] ?? "noImageAvailable") else { return }
        
        // transfer data
        let nextVC = MoodBoardViewController()
    }
    
    @objc private func saveNoteWithoutDetails() {
        // just save the note
        saveWithoutDetails()
    }
    
    private func saveWithoutDetails() {
        // make data for transfer
        guard let moodLabelText = moodLabel.text,
              let moodImage = UIImage(named: moodLabelText),
              let backgroundImage = UIImage(named: moodBackgroundChoice[moodLabelText] ?? "noImageAvailable") else { return }
        
        let newNote = formNewNote()
        newNote.mood = moodImage
        newNote.backGroundImage = backgroundImage
        newNote.moodDescription = moodLabelText
        newNote.reasonsDescription = "You preferred not to describe your feelings"
        
        // handle data to the delegate
        handleUpdatedDataDelegate?.onDataUpdate(data: newNote)
        
        // go to rootVC
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func formNewNote() -> MoodNote {
        let newNote = MoodNote(context: self.context)
        newNote.day = setTheDate(with: "dd")
        newNote.month = setTheDate(with: "LLL")
        newNote.time = setTheDate(with: "HH:mm")
        
        return newNote
    }
    
    private func setTheDate(with dateFormat: String) -> String {
        let dateNow = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.string(from: dateNow)
        
        return date
    }
    
    // MARK: UI setup
    
    private func setupUI() {
        setupBackGroundTopGradientImage()
        setupBackGroundBottomGradientImage()
        
        setupDismissButton()
        setupBottomButtonStackView()
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
    
    private func setupDismissButton() {
        view.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5)
        ])
    }
    
    private func setupBottomButtonStackView() {
        view.addSubview(bottomButtonStackView)
        bottomButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomButtonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            bottomButtonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            bottomButtonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -42)
        ])
    }

}

extension AddMoodViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return moodPickerModels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 300.0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 300.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let model = moodPickerModels[row]
        return MoodImageView.create(icon: model.icon)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickerView.subviews[1].backgroundColor = .clear
        
        let model = moodPickerModels[row]
        
        switch model.icon {
        case UIImage(named: "Happy"):
            moodLabel.text = "Happy"
        case UIImage(named: "Resentment"):
            moodLabel.text = "Resentment"
        default: moodLabel.text = "Name Error"
        }
    }
}

private extension AddMoodViewController {
    func pickerViewSetup() {
        pickerView.delegate = self
        pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView.subviews[1].backgroundColor = .clear
    }
}
