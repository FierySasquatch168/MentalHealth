//
//  AddMoodViewController.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

class AddMoodViewController: DiaryModuleViewController, ReasonsUpdateDelegate, UpdatingDataControllerProtocol {
    
    // Protocol conformance
    var updatingData: [MoodNote] = []
    var mood: UIImage?
    var backgroundImage: UIImage?
    var moodDescription: String?
    
    private let moodBackgroundChoice = ["Happy":"Rectangle 15", "Resentment":"Rectangle 14"]
    var handleUpdatedDataDelegate: DataUpdateDelegate?
    
    // MARK: Middle stack view content
    private lazy var howDoYouFeelLabel: UILabel = {
        let label = UILabel()
        label.text = "How do you feel?"
        label.font = UIFont(name: CustomFont.kyivTypeSansMedium3.rawValue, size: 30)
        
        return label
    }()
    
    private lazy var swipeUpOrDownLabel: UILabel = {
        let label = UILabel()
        label.text = "Swipe up or down"
        label.font = UIFont(name: CustomFont.InterLight.rawValue, size: 20)
        
        return label
    }()
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        
        return pickerView
    }()
    
    private lazy var moodLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.kyivTypeSansRegular2.rawValue, size: 30)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    // MARK: PickerContent
    
    private lazy var moodPickerModels: [MoodPickerModel] = {
        var models: [MoodPickerModel] = []
        
        for value in MoodModelForPickerView.moods {
            models.append(.init(icon: value))
        }
        
        return models
    }()
    
    
    
    // MARK: Stackview properties
    
    private lazy var middleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.alignment = .center
        
        stackView.addArrangedSubview(howDoYouFeelLabel)
        stackView.addArrangedSubview(swipeUpOrDownLabel)
        stackView.addArrangedSubview(pickerView)
        
        return stackView
    }()
    
    private lazy var bottomButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 17
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(addButton)
        stackView.addArrangedSubview(saveButton)
        
        return stackView
    }()
    
    // MARK: Buttons
    
    private lazy var addButton: BottomActionButton = {
        let button = BottomActionButton(color: .customPurple ?? .black, title: "Add")
        button.heightAnchor.constraint(equalToConstant: 61).isActive = true
        button.addTarget(self, action: #selector(addNote), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var saveButton: BottomActionButton = {
        let button = BottomActionButton(color: .customPurple ?? .black, title: "Save")
        button.heightAnchor.constraint(equalToConstant: 61).isActive = true
        button.addTarget(self, action: #selector(saveNoteWithoutDetails), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
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
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backgroundTopGradientImage")
        return imageView
    }()
    
    private lazy var backgroundBottomGradientImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backgroundBottomGradientImage")
        return imageView
    }()

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
        pickerViewSetup()
        setupMoodLabel()
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
    
    // MARK: Delegate func
    
    // saving note through delegate from the moodBoardVC
    func saveNote(data: MoodNote) {
        // handle data to delegate
        handleUpdatedDataDelegate?.onDataUpdate(data: data)
        
        // pop to root VC
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: @OBJC funcs
    
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
        nextVC.mood = moodImage
        nextVC.backgroundImage = actualBackgroundImage
        nextVC.moodDescription = moodLabelText
        
        // set self as the delegate
        nextVC.handleUpdatedDataDelegate = self
        
        goToNextVC(viewController: nextVC)
    }
    
    @objc private func saveNoteWithoutDetails() {
        // just save the note
        saveWithoutDetails()
    }
    
    // MARK: Private funcs
    
    private func goToNextVC(viewController: UIViewController) {
        navigationController?.present(viewController, animated: true)
    }
    
    private func saveWithoutDetails() {
        // make data for transfer
        guard let moodLabelText = moodLabel.text,
                let moodImage = UIImage(named: moodLabelText),
                let backgroundImage = UIImage(named: moodBackgroundChoice[moodLabelText] ?? "noImageAvailable")
        else {
            return
        }
        
        let newNote = formNewNote()
        newNote.mood = moodImage
        newNote.backgroundImage = backgroundImage
        newNote.moodDescription = moodLabelText
        newNote.reasonsDescription = "You preferred not to describe your feelings"
        
        // handle data to the delegate
        handleUpdatedDataDelegate?.onDataUpdate(data: newNote)
        
        // go to rootVC
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: UI setup
    
    private func setupUI() {
        setupBackGroundTopGradientImage()
        setupBackGroundBottomGradientImage()
        
        setupDismissButton()
        setupBottomButtonStackView()
        setupMiddleStackView()
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
    // MARK: StackView UI
    
    private func setupMiddleStackView() {
        view.addSubview(middleStackView)
        middleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            middleStackView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 41),
            middleStackView.bottomAnchor.constraint(equalTo: bottomButtonStackView.topAnchor, constant: -54),
            middleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            middleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
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
    
    private func setupMoodLabel() {
        view.addSubview(moodLabel)
        moodLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            moodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moodLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            moodLabel.bottomAnchor.constraint(equalTo: middleStackView.bottomAnchor, constant: -43)
        ])
    }

}

// MARK: Extensions

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
