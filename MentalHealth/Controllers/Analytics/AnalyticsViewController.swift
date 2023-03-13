//
//  AnalyticsViewController.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit
import Charts

class AnalyticsViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<String, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, String>
    
    private var chartValues: [Double] = [49, 17, 17, 17]
    private var timeOptions = ["This week", "30 days", "All time"]
    
    private var reasons = ["Reasons", "Fetching", "Error"]
    private var feelings = ["loneliness", "sad", "anger"]
    
    private var headers = ["It upsets me mostly", "That's why I feel"]
    
    // MARK: Collection view
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    private var dataSource: DataSource?
    private var analyticsProvider: AnalyticsProviderProtocol?
    
    
    private var analyticsViewIsHidden: Bool = true {
        didSet {
            // В таком виде работает ок
            switch self.analyticsViewIsHidden {
            case true:
                pieChartStackView.isHidden = true
                lineChart.isHidden = false
                graphicsButton.setTitleColor(.black, for: .normal)
                analyticsButton.setTitleColor(.customChartButton, for: .normal)
            case false:
                pieChartStackView.isHidden = false
                lineChart.isHidden = true
                analyticsButton.setTitleColor(.black, for: .normal)
                graphicsButton.setTitleColor(.customChartButton, for: .normal)
            }
        }
    }
    
    // MARK: Stack Views
    
    private lazy var topButtonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 120
        
        return stack
    }()
    
    private lazy var pieChartStackView: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(chartBackgroundCircle)
        stack.addArrangedSubview(pieChart)
        
        // TODO: add characteristics
        
        pieChart.centerYAnchor.constraint(equalTo: chartBackgroundCircle.centerYAnchor).isActive = true
        pieChart.centerXAnchor.constraint(equalTo: chartBackgroundCircle.centerXAnchor).isActive = true
        
        return stack
    }()
    
    // MARK: UI elements
    
    private lazy var analyticsButton: ChartViewButton = {
        let button = ChartViewButton(title: "Analytics")
        button.addTarget(self, action: #selector(changeChartView), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var graphicsButton: ChartViewButton = {
        let button = ChartViewButton(title: "Graphics")
        button.addTarget(self, action: #selector(changeChartView), for: .touchUpInside)

        return button
    }()
    
    private lazy var timePick: CustomSegmentedControl = {
        let timePick = CustomSegmentedControl(items: timeOptions)
        timePick.addTarget(self, action: #selector(setTimeInterval), for: .valueChanged)
        return timePick
    }()
    
    private let moodLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Mood"
        label.font = UIFont(name: CustomFont.kyivTypeSansBold3.rawValue, size: 30)
        label.textAlignment = .center
        return label
    }()
    
    private let timePeriod: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.kyivTypeSansRegular2.rawValue, size: 20)
        label.textAlignment = .center
        label.textColor = .customChartButton
        
        return label
    }()
    
    // MARK: PieChart
    
    private lazy var pieChart: PieChartView = {
        let pieChart = PieChartView()
        pieChart.delegate = self
        var entries: [PieChartDataEntry] = []
        
        // set values for the chart
        for i in 0..<chartValues.count {
            let value = PieChartDataEntry(value: chartValues[i])
            entries.append(value)
        }
        // set colors to the chart
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = [
            NSUIColor(cgColor: UIColor.customGreen.cgColor),
            NSUIColor(cgColor: UIColor.customLighBlue.cgColor),
            NSUIColor(cgColor: UIColor.customOrange.cgColor),
            NSUIColor(cgColor: UIColor.customYellow.cgColor)
        ]
        
        // connect chart data to the entry values
        dataSet.drawValuesEnabled = false
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        
        // correct UI
        pieChart.holeRadiusPercent = CGFloat(0.65)
        pieChart.legend.enabled = false
        pieChart.clipsToBounds = true
        
        return pieChart
    }()
    
    // MARK: PieChart properties
    
    private lazy var chartBackgroundCircle: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Ellipse 21")
        image.clipsToBounds = true
        
        return image
    }()
    
    private lazy var chartCharacteristicsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 0
        stack.clipsToBounds = true
        stack.backgroundColor = .clear
        
        stack.addArrangedSubview(chartCharacteristic)
        stack.addArrangedSubview(percentage)
        stack.addArrangedSubview(numberOfNotes)
        
        return stack
    }()
    
    private lazy var chartCharacteristic: UILabel = {
        var label = UILabel()
        label.text = "Normal"
        label.font = UIFont(name: CustomFont.kyivTypeSansBold3.rawValue, size: 22)
        label.numberOfLines = 1
        label.textColor = .customChartButton
        label.textAlignment = .center
        return label
    }()
    
    private lazy var percentage: UILabel = {
        var percentage = UILabel()
        percentage.text = "\(Int(chartValues[0])) %"
        percentage.font = UIFont(name: CustomFont.kyivTypeSansBold3.rawValue, size: 40)
        percentage.numberOfLines = 1
        percentage.textColor = .black
        percentage.textAlignment = .center
        return percentage
    }()
    
    private lazy var numberOfNotes: UIButton = {
        var button = UIButton()
        let string = "\(chartValues.count) notes"
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: CustomFont.kyivTypeSansBold3.rawValue, size: 20) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.customChartButton as Any
        ]
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        
        return button
    }()
    
    // MARK: Line chart
    
    private lazy var lineChart: LineChartView = {
        let lineChart = LineChartView()
        lineChart.delegate = self
        
        var entries: [ChartDataEntry] = []
        
        // set values for the chart
        for i in 0..<chartValues.count {
            let value = ChartDataEntry(x: chartValues[i], y: chartValues[i])
            entries.append(value)
        }
        // set colors to the chart
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.colors = [
            NSUIColor(cgColor: UIColor.customGreen.cgColor),
            NSUIColor(cgColor: UIColor.customLighBlue.cgColor),
            NSUIColor(cgColor: UIColor.customOrange.cgColor),
            NSUIColor(cgColor: UIColor.customYellow.cgColor)
        ]
        
        let data = LineChartData(dataSet: dataSet)
        lineChart.data = data
        lineChart.isHidden = true
        
        return lineChart
    }()
    
    // MARK: Background style properties
    
    private lazy var backGroundTopImage: UIImageView = {
        let topImage = UIImageView()
        topImage.backgroundColor = .clear
        topImage.image = UIImage(named: "backgroundTopGradientImage")
        return topImage
    }()
    
    private lazy var backgroundBottomImage: UIImageView = {
        let bottomImage = UIImageView()
        bottomImage.backgroundColor = .clear
        bottomImage.image = UIImage(named: "backgroundBottomGradientImage")
        return bottomImage
    }()
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        analyticsProvider = AnalyticsProvider(dataConverter: DataConverter(), coreDataManager: CoreDataManager.shared)
        analyticsProvider?.fetchModelForAnalysis()
        
        setupUI()
        setupCollectionView()
        createDataSource()
        
        setTimeInterval(timePick)
        analyticsViewIsHidden = false
    }
    
    // MARK: Behavior
    
    private func enablePieChart() {
        pieChartStackView.isHidden = false
        lineChart.isHidden = true
        analyticsButton.setTitleColor(.black, for: .normal)
        graphicsButton.setTitleColor(.customChartButton, for: .normal)
    }
    
    private func createTimeInterval(days: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.LL.YYYY"
        
        let timeInterval = TimeInterval(days*24*60*60)
        
        let date = Date(timeInterval: -timeInterval, since: Date())
        
        let keyDate = dateFormatter.string(from: date)
        let today = dateFormatter.string(from: Date())
        
        return "\(keyDate) - \(today)"
    }
    
    // MARK: @objs funcs
    
    @objc private func setTimeInterval(_ segmentControl: UISegmentedControl) {
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            timePeriod.text = createTimeInterval(days: 7)
        case 1:
            timePeriod.text = createTimeInterval(days: 30)
        default:
            timePeriod.text = createTimeInterval(days: 100)
        }
    }
    
    @objc private func changeChartView() {
        analyticsViewIsHidden.toggle()
    }
    
    // MARK: CollectionView setup
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        
        // MARK: Cell registration
        collectionView.register(ReasonsCollectionViewCell.self, forCellWithReuseIdentifier: ReasonsCollectionViewCell.reuseIdentifier)
        collectionView.register(FeelingsCollectionViewCell.self, forCellWithReuseIdentifier: FeelingsCollectionViewCell.reuseIdentifier)
        
        // MARK: SectionHeader
        collectionView.register(AnalyticsCustomHeaderForCV.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AnalyticsCustomHeaderForCV.reuseIdentifier)
        
        collectionView.contentInset = UIEdgeInsets(top: 14, left: 14, bottom: -14, right: -14)
        self.collectionView.backgroundColor = .customCVBackground
        collectionView.layer.cornerRadius = 12
        
        // MARK: CollectionView constraints
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: pieChartStackView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: DataSource
    
    private func createDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, itemIdentifier in
            return self.cell(collectionView: collectionView, indexPath: indexPath, item: itemIdentifier)
        })
        
        guard let dataSource = dataSource else { return }
        
        dataSource.supplementaryViewProvider = { [unowned self] (collectionView, kind, indexPath) in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AnalyticsCustomHeaderForCV.reuseIdentifier, for: indexPath) as? AnalyticsCustomHeaderForCV else { return UICollectionReusableView() }
            
            if indexPath.section == 0 {
                header.configure(with: self.headers[0])
            } else if indexPath.section == 1 {
                header.configure(with: self.headers[1])
            }
            
            return header
        }
        
        dataSource.apply(createSnapshot())
    }
    
    // MARK: Cell
    
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: String) -> UICollectionViewCell {
        switch headers[indexPath.section] {
        case headers[0]:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReasonsCollectionViewCell.reuseIdentifier, for: indexPath) as? ReasonsCollectionViewCell else { return UICollectionViewCell() }
            cell.configureReasonsButton(item: item)
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeelingsCollectionViewCell.reuseIdentifier, for: indexPath) as? FeelingsCollectionViewCell else { return UICollectionViewCell() }
            cell.configureFeelingsButton(item: item)
            return cell
        }
    }
    
    private func createSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections(headers)
        // MARK: reasons connected to the model
        guard let model = analyticsProvider?.deliverModelForPresentation() else { fatalError("analytics model is not connected") }
        snapshot.appendItems(model, toSection: headers[0])
        // TODO: Connect feeling to the model somehow
        snapshot.appendItems(feelings, toSection: headers[1])
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
            return createReasonsSection()
        default:
            return createFeelingsSection()
        }
    }
    
    private func createReasonsSection() -> NSCollectionLayoutSection {
        // itemsize - item - groupsize - group - section
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(collectionView.frame.size.width), heightDimension: .fractionalHeight(0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
        
        addStandardHeader(toSection: section)
        
        return section
    }
    
    private func createFeelingsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(collectionView.frame.size.width), heightDimension: .fractionalHeight(0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
        
        addStandardHeader(toSection: section)
        
        return section
    }
    
    // MARK: SectionHeader
    
    private func addStandardHeader(toSection section: NSCollectionLayoutSection) {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [headerElement]
    }
    
    

    
}

// MARK: Extension Charts

extension AnalyticsViewController: ChartViewDelegate {
    
}

// MARK: UI Setup

extension AnalyticsViewController {
    
    private func setupUI() {
        setupBackgroundTopView()
        setupBackgroundBottomView()
        setupTopButtonStackView()
        setupPieChartStackView()
        setupLineChartView()
        setupTimePick()
        setupMoodLabel()
        setupTimePeriodLabel()
        
    }
    
    private func setupBackgroundTopView() {
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
    
    private func setupTopButtonStackView() {
        view.addSubview(topButtonStackView)
        topButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        topButtonStackView.addArrangedSubview(analyticsButton)
        topButtonStackView.addArrangedSubview(graphicsButton)
        
        NSLayoutConstraint.activate([
            topButtonStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            topButtonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            topButtonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            topButtonStackView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setupTimePick() {
        view.addSubview(timePick)
        timePick.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timePick.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            timePick.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 27),
            timePick.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -27)
        ])
    }
    
    private func setupPieChartStackView() {
        view.addSubview(pieChartStackView)
        pieChartStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pieChartStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pieChartStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 178),
            pieChartStackView.heightAnchor.constraint(equalToConstant: 280),
            pieChartStackView.widthAnchor.constraint(equalToConstant: 280)
        ])
    }
    
    private func setupLineChartView() {
        view.addSubview(lineChart)
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lineChart.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lineChart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 178),
            lineChart.heightAnchor.constraint(equalToConstant: 280),
            lineChart.widthAnchor.constraint(equalToConstant: 280)
        ])
    }
    
    private func setupMoodLabel() {
        view.addSubview(moodLabel)
        moodLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            moodLabel.topAnchor.constraint(equalTo: timePick.bottomAnchor, constant: 22),
            moodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            moodLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80)
        ])
    }
    
    private func setupTimePeriodLabel() {
        view.addSubview(timePeriod)
        timePeriod.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timePeriod.topAnchor.constraint(equalTo: moodLabel.bottomAnchor),
            timePeriod.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 72),
            timePeriod.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -72)
        ])
    }
}
