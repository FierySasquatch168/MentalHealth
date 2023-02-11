//
//  LibraryViewController.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

class LibraryViewController: UIViewController {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<String, Article>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<String, Article>
    
    // MARK: Dataflow
    private let constants = Constants.shared
    private var articleFactory: ArticleFactoryProtocol?
    private var articles: [Article] = []
    private var popularArticles: [Article] = []
    private var newArticle: [Article] = []
    private var headers = ["Inspiration", "Popular", "New"]
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        
        // MARK: UICV cells
        collectionView.register(LibraryCustomInspirationCell.self, forCellWithReuseIdentifier: LibraryCustomInspirationCell.reuseIdentifier)
        collectionView.register(LibraryCustomPopularCell.self, forCellWithReuseIdentifier: LibraryCustomPopularCell.reuseIdentifier)
        collectionView.register(LibraryCustomNewCell.self, forCellWithReuseIdentifier: LibraryCustomNewCell.reuseIdentifier)
        
        // MARK: UICV header
        collectionView.register(LibraryCustomHeaderForCellReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LibraryCustomHeaderForCellReusableView.reuseIdentifier)
        
        return collectionView
    }()
    
    
    private var dataSource: DataSource!
    
    // MARK: Background Style properties
    private var backGroundTopImage: UIImageView = {
        let topImage = UIImageView()
        topImage.backgroundColor = .clear
        topImage.image = UIImage(named: "backgroundTopmGradientImage")
        return topImage
    }()
    
    private var backgroundBottomImage: UIImageView = {
        let bottomImage = UIImageView()
        bottomImage.backgroundColor = .clear
        bottomImage.image = UIImage(named: "backgroundBottomGradientImage")
        return bottomImage
    }()
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        articleFactory = ArticleFactory(delegate: self, articlesLoader: ArticlesLoader())
        articleFactory?.loadData()
        
        self.navigationController?.navigationBar.isHidden = true
        
        setupBackroundTopView()
        setupBackgroundBottomView()
        setupCollectionView()
        
        self.collectionView.backgroundColor = .clear
        
    }
    
    // MARK: CollectionView
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -37)
        ])
        
    }
    
    // MARK: Create Diffable DataSource (called in delegate method didReceiveArticle after articles.count got data from Factory)
    
    private func createDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, itemIdentifier in
            return self.cell(collectionView: collectionView, indexPath: indexPath, item: itemIdentifier)
        })
        
        dataSource.supplementaryViewProvider = { [unowned self] (collectionView, kind, indexPath) in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LibraryCustomHeaderForCellReusableView.reuseIdentifier, for: indexPath) as? LibraryCustomHeaderForCellReusableView else { fatalError() }
            
            if indexPath.section == 0 {
                header.configure(with: self.headers[0])
            } else if indexPath.section == 1 {
                header.configure(with: self.headers[1])
            } else if indexPath.section == 2 {
                header.configure(with: self.headers[2])
            } else {
                header.configure(with: "Header Error, check headers of SupplementaryViewProvider")
            }
            
            return header
        }
        
        dataSource.apply(createSnapshot())
        
    }
    
    // MARK: Cell configuration
    
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: Article) -> UICollectionViewCell {
        switch headers[indexPath.section] {
        case "New":
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCustomNewCell.reuseIdentifier, for: indexPath) as? LibraryCustomNewCell else { fatalError()}
            // TODO: configure the cell
            return cell
        case "Popular":
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCustomPopularCell.reuseIdentifier, for: indexPath) as? LibraryCustomPopularCell else { fatalError()}
            // TODO: configure the cell
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCustomInspirationCell.reuseIdentifier, for: indexPath) as? LibraryCustomInspirationCell else { fatalError()}
            // TODO: configure the cell
            return cell
        }
    }
    
    // MARK: Snapshot
    
    private func createSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections(headers)
        snapshot.appendItems(articles, toSection: headers[0])
        snapshot.appendItems(popularArticles, toSection: headers[1])
        snapshot.appendItems(newArticle, toSection: headers[2])
        return snapshot
    }
    
    // MARK: Layout
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] sectionIndex, environment in
            return self.sectionFor(index: sectionIndex, environment: environment)
            
        }
    }
    
    // MARK: Sections
    
    private func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let section = headers[index]
        
        switch section {
        case headers[0]:
            return createInspirationArticlesSection()
        case headers[1]:
            return createPopularArticlesSection()
        default:
            return createNewArticlesSection()
        }
    }
    
    private func createInspirationArticlesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(72), heightDimension: .absolute(72))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.15))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 23, bottom: 0, trailing: 0)
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        addStandardHeader(toSection: layoutSection)
        layoutSection.orthogonalScrollingBehavior = .continuous
        
        return layoutSection
    }
    
    private func createPopularArticlesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 23, bottom: 0, trailing: 23)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [layoutItem])
        let section = NSCollectionLayoutSection(group: group)
        addStandardHeader(toSection: section)

        return section
    }
    
    private func createNewArticlesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [layoutItem])
        let section = NSCollectionLayoutSection(group: group)
        addStandardHeader(toSection: section)

        return section
    }
    
    // MARK: Header
    
    private func addStandardHeader(toSection section: NSCollectionLayoutSection) {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [headerElement]
    }
    
    // MARK: UI Configuration
    
    private func setupBackroundTopView() {
        view.addSubview(backGroundTopImage)
        backGroundTopImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backGroundTopImage.topAnchor.constraint(equalTo: view.topAnchor),
            backGroundTopImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backGroundTopImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupBackgroundBottomView() {
        view.addSubview(backgroundBottomImage)
        backgroundBottomImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundBottomImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundBottomImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundBottomImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }


}

// MARK: Extension Delegate

extension LibraryViewController: ArticleFactoryDelegate {
    func didReceiveArticle(articles: [Article], popularArticles: [Article], newArticle: [Article]) {
        self.articles = articles
        self.popularArticles = popularArticles
        self.newArticle = newArticle
        
        createDataSource()
    }
    
    
}
