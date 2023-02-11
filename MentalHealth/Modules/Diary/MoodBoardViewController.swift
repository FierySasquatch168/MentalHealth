//
//  MoodBoardViewController.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

class MoodBoardViewController: DiaryModuleViewController, UpdatingDataControllerProtocol {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<String, ReasonButtonModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<String, ReasonButtonModel>
    
    // Protocol conformance
    var updatingData: [MoodNote] = []
    var mood: UIImage?
    var backgroundImage: UIImage?
    var moodDescription: String?
    
    // Reasons to send to tableView
    private var collectionViewButtonMockData: [String: String] = [
        "Work" : "Business",
        "Friends" : "Friends",
        "Relax" : "Lotus",
        "Study" : "Student Male",
        "Love" : "Romance",
        "Weather" : "Partly Cloudy Day",
        "Family" : "Home Page",
        "Vacation" : "Airport"
    ]
    private var buttonsForCollectionView: [ReasonButtonModel] = []
    private var sections = ["Main"]
    private let moodBackgroundChoice = ["Happy":"Rectangle 15", "Resentment":"Rectangle 14"]
    private var chosenReasons = [String]()
    
    // Delegate
    var handleUpdatedDataDelegate: ReasonsUpdateDelegate?
    
    // CollectionView and DataSource
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(ReasonCustomCollectionViewCell.self, forCellWithReuseIdentifier: ReasonCustomCollectionViewCell.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private var dataSource: DataSource!
    
    // MARK: TOP lazy properties
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark")
        image?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(dismissToPreviousScreen), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = mood
        return imageView
    }()
    
    private lazy var topMoodAndDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.addArrangedSubview(topMoodLabel)
        stackView.addArrangedSubview(topDateDescriptionLabel)
        return stackView
    }()
    
    private lazy var topMoodLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.kyivTypeSansRegular2.rawValue, size: 25)
        label.textAlignment = .center
        label.text = moodDescription
        return label
    }()
    
    private lazy var topDateDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.InterLight.rawValue, size: 20)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var tellMeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.kyivTypeSansMedium3.rawValue, size: 30)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Tell me what's going on with you?"
        return label
    }()
    
    // MARK: Bottom lazy properties
    
    private lazy var bottomSheet: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customTextView
        button.setTitleColor(.customDate, for: .normal)
        let title = "Write down your thoughts"
        let attribute = [NSAttributedString.Key.font: UIFont(name: CustomFont.InterLight.rawValue, size: 14)]
        let attributedTitle = NSAttributedString(string: title, attributes: attribute as [NSAttributedString.Key : Any])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.layer.cornerRadius = 32
        button.contentVerticalAlignment = .top
        button.contentHorizontalAlignment = .leading
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 28, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(didTapBottomSheet), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomRectangle: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Rectangle 13")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var saveButton: BottomActionButton = {
        let button = BottomActionButton(color: .customPurple ?? .black, title: "Save")
        button.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(saveDidTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
                
        setupUpperUI()
        setupCollectionView()
        
        createDataSourceMockModel()
        createDataSource()
        
        setupLowerUI()
        
    }
    
    private func setDateAndTimeOfNote() {
        // Form custom date
        let dayNow = Date()
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        let day = dayFormatter.string(from: dayNow)
        
        dayFormatter.locale = Locale(identifier: "en_US")
        dayFormatter.dateFormat = "LLLL"
        let month = dayFormatter.string(from: dayNow)
        
        dayFormatter.dateFormat = "HH:mm"
        let time = dayFormatter.string(from: dayNow)
        
        topDateDescriptionLabel.text = "today, \(month) \(day)\n at \(time)"
    }
    
    private func createDataSourceMockModel() {
        let color = UIColor.customButtonPurple ?? .black
        let button = CustomReasonButton(color: color)
        
        for (key, value) in collectionViewButtonMockData {
            let model = ReasonButtonModel(button: CustomReasonButton(color: .customButtonPurple ?? .black), imageName: value, buttonTitle: key)
            buttonsForCollectionView.append(model)
        }
    }
    
    // MARK: CollectionView setup
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: tellMeLabel.bottomAnchor, constant: 38),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -190)
        ])
    }
    
    // MARK: UICV dataSource setup
    private func createDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { [unowned self] (collectionView, indexPath, itemIdentifier) in
            return self.cell(collectionView: collectionView, indexPath: indexPath, item: itemIdentifier)
        })
                
        dataSource?.apply(createSnapshot())
        
    }
    
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: ReasonButtonModel) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReasonCustomCollectionViewCell.reuseIdentifier, for: indexPath) as? ReasonCustomCollectionViewCell else { fatalError("Can not configure custom CV cell in MoodBoardVC") }
        cell.setCellWithValuesOf(item: item)
        cell.delegate = self
        return cell
    }
    
    private func createSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        snapshot.appendItems(buttonsForCollectionView, toSection: sections[0])
        return snapshot
    }
    
    // MARK: Create UICollectionView layouts
    
//    private func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
//        return createLayout()
//    }
//
//    private func createCompositionalLayout() -> UICollectionViewLayout {
//        return UICollectionViewCompositionalLayout { [unowned self] sectionIndex, environment in
//            return self.sectionFor(index: sectionIndex, environment: environment)
//        }
//    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(68), heightDimension: .absolute(68))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.55))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.interItemSpacing = .fixed(15.0)
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        let layout = UICollectionViewCompositionalLayout(section: layoutSection)
        return layout
        
    }
    
    // MARK: @OBJC funcs
    
    @objc private func dismissToPreviousScreen() {
        dismiss(animated: true)
    }
    
    @objc private func saveDidTapped() {
        // Data for transfer
        let newNote = MoodNote(context: self.context)
        newNote.day = setTheDateForNote(with: "dd")
        newNote.month = setTheDateForNote(with: "LLL")
        newNote.time = setTheDateForNote(with: "HH:mm")
        
        guard let moodLabelText = topMoodLabel.text,
                let moodImage = UIImage(named: moodLabelText),
                let backgroundImage = UIImage(named: moodBackgroundChoice[moodLabelText]!)
        else { return }
        
        newNote.mood = moodImage
        newNote.backgroundImage = backgroundImage
        newNote.moodDescription = moodLabelText
        newNote.reasonsDescription = chosenReasons.isEmpty ? "You preferred not to describe the reasons" : chosenReasons.joined(separator: ", ")
        
        // Handle data to delegate
        handleUpdatedDataDelegate?.saveNote(data: newNote)
                
        // Return to rootVC
        goToRootVC()
    }
    
    @objc private func didTapBottomSheet() {
        let singleNoteVC = SingleNoteViewController()
        self.present(singleNoteVC, animated: true)
    }
    
    // MARK: Private funcs
    
    private func goToRootVC() {
        self.dismiss(animated: true)
    }
    
    // MARK: UI setup
    
    private func setupUpperUI() {
        setupTopImageView()
        setupTopMoodAndDateStackView()
        setupTellMeLabel()
        setupDismissButton()
        setDateAndTimeOfNote()
    }
    
    private func setupLowerUI() {
        setupBottomSheet()
        setupBottomRectangle()
        setupSaveButton()
    }
    
    private func setupTopImageView() {
        view.addSubview(topImageView)
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            topImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 125),
            topImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -125),
            topImageView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 145)
        
        ])
    }
    
    private func setupTopMoodAndDateStackView() {
        view.addSubview(topMoodAndDateStackView)
        topMoodAndDateStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topMoodAndDateStackView.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 5),
            topMoodAndDateStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            topMoodAndDateStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70)
        ])
    }
    
    private func setupTellMeLabel() {
        view.addSubview(tellMeLabel)
        tellMeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tellMeLabel.topAnchor.constraint(equalTo: topMoodAndDateStackView.bottomAnchor, constant: 13),
            tellMeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            tellMeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38)
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
    
    private func setupBottomSheet() {
        view.addSubview(bottomSheet)
        bottomSheet.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            bottomSheet.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 37),
            bottomSheet.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            bottomSheet.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            bottomSheet.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBottomRectangle() {
        view.addSubview(bottomRectangle)
        bottomRectangle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomRectangle.topAnchor.constraint(equalTo: bottomSheet.topAnchor, constant: 50),
            bottomRectangle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomRectangle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomRectangle.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSaveButton() {
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 65),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 115),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -115),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

// MARK: Extension CellDelegate

extension MoodBoardViewController: ReasonCustomCollectionViewCellDelegate {
    func didTapButton(with title: String) {
        if chosenReasons.contains(title) {
            chosenReasons.removeAll(where: { $0 == title })
        } else {
            chosenReasons.append(title)
        }
    }
}
