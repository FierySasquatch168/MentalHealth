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
    var updatingData: [MoodNote] = []
    var mood: UIImage?
    var backgroundImage: UIImage?
    var moodDescription: String?
    
    // Reasons to send to tableView
    var chosenReasons = [String]()
    var reasonsDictionary: [UIButton : String] = [:]
    private let moodBackgroundChoice = ["Happy":"Rectangle 15", "Resentment":"Rectangle 14"]
    private var buttonImageNamesTop: [String] = ["Business", "Friends", "Lotos", "Student Male", "Romance", "Partly Cloudy", "Home Page", "Airport"]
    private var buttonsForCollectionView: [ReasonButtonModel] = []
    private var sections = ["Section"]
    
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
        return imageView
    }()
    
    private lazy var topMoodAndDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.addArrangedSubview(topMoodLabel)
        stackView.addArrangedSubview(topDateDescriptionLabel)
        return stackView
    }()
    
    private lazy var topMoodLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.kyivTypeSansRegular2.rawValue, size: 25)
        label.textAlignment = .center
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
        
    }
    
    // MARK: CollectionView setup
    
    private func setupCollectionView() {
        let layout = UICollectionViewLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: tellMeLabel.bottomAnchor, constant: 38),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -215)
        ])
        
        // MARK: UICV cells registration
        collectionView.register(ReasonCustomCollectionViewCell.self, forCellWithReuseIdentifier: ReasonCustomCollectionViewCell.reuseIdentifier)
    }
    
    private func createDataSource() {
        guard let collectionView = collectionView else { return }
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, itemIdentifier in
            return self.cell(collectionView: collectionView, indexPath: indexPath, item: itemIdentifier)
        })
        
        dataSource.apply(createSnapshot())
    }
    
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: ReasonButtonModel) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReasonCustomCollectionViewCell.reuseIdentifier, for: indexPath) as? ReasonCustomCollectionViewCell else { fatalError("Can not configure custom CV cell in MoodBoardVC") }
        cell.setCellWithValuesOf(item: item)
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
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
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
