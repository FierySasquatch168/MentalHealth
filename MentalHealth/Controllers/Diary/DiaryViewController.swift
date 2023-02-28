//
//  DiaryViewController.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

// TODO: set tableView delegate, finish single note screen, check tabbar appearence
final class DiaryViewController: DiaryModuleViewController, CoreDataManagerDelegate {
    private var updatedNotes: [MoodNote] = [] {
        didSet {
            setupMiddleStackView()
        }
    }
    
    // MARK: TableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.frame = view.bounds
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CustomDiaryTableViewCell.self, forCellReuseIdentifier: CustomDiaryTableViewCell.reuseIdentifier)
        
        tableView.backgroundView = middleStackView
        
        return tableView
    }()
    
    // MARK: StackViews
    private lazy var middleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.addArrangedSubview(howDoYouFeelLabel)
        stackView.addArrangedSubview(addFirstNote)
        stackView.addArrangedSubview(mainImageView)
        
        addFirstNote.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 80).isActive = true
        addFirstNote.trailingAnchor.constraint(equalTo: stackView.trailingAnchor,constant: -80).isActive = true
        
        return stackView
    }()
    
    // MARK: Lazy properties
    private lazy var howDoYouFeelLabel: UILabel = {
        let label = UILabel()
        label.text = "How do you feel?"
        label.textAlignment = .center
        label.font = UIFont(name: CustomFont.kyivTypeSansMedium3.rawValue, size: 30)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var addFirstNote: UILabel = {
        let label = UILabel()
        label.text = "Add the first note about your mood"
        label.textAlignment = .center
        label.font = UIFont(name: CustomFont.InterLight.rawValue, size: 20)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Head")
        
        return imageView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Plus Math"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button.backgroundColor = .customPink
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addNewNote), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        // coreDataManagerDelegate
        coreDataManager.delegate = self
                
        // get items from CoreData
        coreDataManager.fetchNotesFromCoreData()
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupAddButton()
    }
    
    // MARK: @Objc funcs
    
    @objc private func addNewNote() {
        let nextVC = AddMoodViewController()
        // set the recent class as delegate
        nextVC.handleUpdatedDataDelegate = self
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func reloadTheTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            print("CoreData Delegate reloadTheTableView works")
        }
    }
    
    // MARK: Setup UI
    
    private func setupUI() {
        setupTableView()
        setupBackgroundView()
        
    }
    
    // MARK: Setup tableView
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBackgroundView() {
        view.addSubview(middleStackView)
        middleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            middleStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 138),
            middleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            middleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            middleStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -95)
        ])
    }
    
    private func setupMiddleStackView() {
        if updatedNotes.isEmpty {
            middleStackView.isHidden = false
        } else {
            middleStackView.isHidden = true
        }
    }
    
    private func setupAddButton() {
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.layer.cornerRadius = addButton.frame.size.width / 2

        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25)
        ])
    }
}

// MARK: Extensions TableView delegate and dataSource

extension DiaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updatedNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomDiaryTableViewCell.reuseIdentifier, for: indexPath) as? CustomDiaryTableViewCell else { return UITableViewCell() }
        let note = updatedNotes[indexPath.row]
        cell.selectionStyle = .none
        cell.set(note: note)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Create swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            // Which note to remove
            let noteToRemove = self.updatedNotes[indexPath.row]
            // Remove the note
            self.coreDataManager.context.delete(noteToRemove)
            // Save the data to Core Data
            do {
                try self.coreDataManager.context.save()
            } catch {
                print(error)
            }
            
            // Re-fetch the data
            self.coreDataManager.fetchNotesFromCoreData()
            self.tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let readNoteVC = ReadNoteViewController()
        readNoteVC.moodNote = updatedNotes[indexPath.row]
        readNoteVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(readNoteVC, animated: true)
    }
}

// MARK: Extension DataUpdateDelegate

extension DiaryViewController: DataUpdateDelegate {
    func onDataUpdate(data: MoodNote) {
        updatedNotes.append(data)
        coreDataManager.saveNotesToCoreData()
        tableView.reloadData()
    }
    
    
}

// MARK: Extension CoreData Delegate

extension DiaryViewController {
    func updateTheNotes(with notes: [MoodNote]) {
        self.updatedNotes = notes
        print("CoreData Delegate updateTheNotes works")
    }
}
