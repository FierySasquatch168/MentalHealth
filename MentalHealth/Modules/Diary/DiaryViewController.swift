//
//  DiaryViewController.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit
import CoreData

class DiaryViewController: UIViewController {
    
    // reference to the managed context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private var updatedNotes: [MoodNote] = [] {
        didSet {
            setupMiddleStackView()
            tableView.reloadData()
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
        
        // get items from CoreData
        fetchNotesFromCoreData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupAddButton()
    }
    
    // MARK: Private funcs
    
    @objc private func addNewNote() {
        let nextVC = AddMoodViewController()
        // set the recent class as delegate
        nextVC.handleUpdatedDataDelegate = self
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // MARK: Core Data functionality
    
    private func fetchNotesFromCoreData() {
        // Fetch the data from CoreData to display in the tableView
        do {
            let request = MoodNote.fetchRequest() as NSFetchRequest<MoodNote>
            self.updatedNotes = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error)
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
        guard let image = UIImage(named: "Head") else { return }
        print("setupBackgroundImage works")
        if updatedNotes.isEmpty {
            print("updatedNotes isEmpty")
            mainImageView.image = image
        } else {
            print("updatedNotes isNotEmpty")
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

// MARK: Extensions

extension DiaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updatedNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomDiaryTableViewCell.reuseIdentifier, for: indexPath) as? CustomDiaryTableViewCell else { return UITableViewCell() }
        let note = updatedNotes[indexPath.row]
        
        cell.set(note: note)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Create swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            // Which note to remove
            let noteToRemove = self.updatedNotes[indexPath.row]
            // Remove the note
            self.context.delete(noteToRemove)
            // Save the data to Core Data
            do {
                try self.context.save()
            } catch {
                print(error)
            }
            
            // Re-fetch the data
            self.fetchNotesFromCoreData()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension DiaryViewController: DataUpdateDelegate {
    func onDataUpdate(data: MoodNote) {
        updatedNotes.append(data)
        
        // Save the data
        do {
            try self.context.save()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    
}
