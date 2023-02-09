//
//  MoodBoardViewController.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

class MoodBoardViewController: UIViewController, UpdatingDataControllerProtocol {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<String, ReasonButtonModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<String, ReasonButtonModel>
  
    // Reference to managed context
    let context = (UIApplication.shared.delegate as! AppDelegate)
    
    // Protocol conformance
    // MARK: Переписать свойства, они сейчас не связаны с UI
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
    
    // Delegate
    var handleUpdatedDataDelegate: ReasonsUpdateDelegate?
    
    // CollectionView and dataSource
    private var collectionView: UICollectionView?
    private var dataSource: DataSource!
    
    // MARK: Lazy properties
    
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
    
    // MARK: Middle buttons stackView
    
    private lazy var singleButtonStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private lazy var topHorizontalButtonStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupUI()
        setupCollectionView()
        createDataSourceMockModel()
        createDataSource()
        setDateAndTimeOfNote()
        
    }
    
    private func setDateAndTimeOfNote() {
        // Формируем дату в нужном виде
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
            let model = ReasonButtonModel(button: button, imageName: value, buttonTitle: key)
            buttonsForCollectionView.append(model)
        }
    }
    
    // MARK: CollectionView setup
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        guard let collectionView = collectionView else { return }
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: tellMeLabel.bottomAnchor, constant: 38),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200)
        ])
        
        // MARK: UICV cells registration
        collectionView.register(ReasonCustomCollectionViewCell.self, forCellWithReuseIdentifier: ReasonCustomCollectionViewCell.reuseIdentifier)
    }
    
    private func createDataSource() {
        guard let collectionView = collectionView else { return }
        print("createDataSource starts")
        dataSource = DataSource(collectionView: collectionView, cellProvider: { [unowned self] (collectionView, indexPath, itemIdentifier) in
            print("createDataSource works")
            return self.cell(collectionView: collectionView, indexPath: indexPath, item: itemIdentifier)
        })
        
        dataSource.apply(createSnapshot())
        print("snapshot applied")
    }
    
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: ReasonButtonModel) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReasonCustomCollectionViewCell.reuseIdentifier, for: indexPath) as? ReasonCustomCollectionViewCell else { fatalError("Can not configure custom CV cell in MoodBoardVC") }
        print("private func cell works")
        cell.setCellWithValuesOf(item: item)
        print("cell.setCellWithValuesOf works")
        return cell
    }
    
    private func createSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        snapshot.appendItems(buttonsForCollectionView, toSection: sections[0])
        return snapshot
    }
    
    // MARK: Create UICollectionView layouts
    
    private func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        return createButtonsSection()
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] sectionIndex, environment in
            return self.sectionFor(index: sectionIndex, environment: environment)
        }
    }
    
    private func createButtonsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(68), heightDimension: .absolute(68))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.55))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.interItemSpacing = .fixed(15.0)
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
        
    }
    
    // MARK: @OBJC funcs
    
    @objc private func dismissToPreviousScreen() {
        dismiss(animated: true)
    }
    
    // MARK: UI setup
    
    private func setupUI() {
        setupTopImageView()
        setupTopMoodAndDateStackView()
        setupTellMeLabel()
        setupDismissButton()
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

}

extension MoodBoardViewController: UICollectionViewDelegate {
    
}
