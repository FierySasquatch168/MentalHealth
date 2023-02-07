//
//  CustomDiaryTableViewCell.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

class CustomDiaryTableViewCell: UITableViewCell {
    
    // main stack of the cell
    private lazy var mainStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 14
        stackView.distribution = .fill
        stackView.addArrangedSubview(dateStackView)
        stackView.addArrangedSubview(moodBoardStackView)
        
        return stackView
    }()
    
    // left stack with day and month
    
    private lazy var dateStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(monthLabel)
        
        return stackView
    }()
    
    // right stack with images and mood description
    
    private lazy var moodBoardStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.addArrangedSubview(backgroundImageStackView)
        stackView.addArrangedSubview(moodDescriptionStackView)
        
        return stackView
    }()
    
    // background image of the right stack with images
    
    private lazy var backgroundImageStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.addArrangedSubview(backgroundImage)
        
        return stackView
    }()
    
    // right upper stack with moodImage and time/feeling/reasons
    
    private lazy var moodDescriptionStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.addArrangedSubview(moodImageStackView)
        stackView.addArrangedSubview(timeFeelingReasonsStackView)
        
        return stackView
    }()
    
    // moodImage of the right stackView
    
    private lazy var moodImageStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        
        stackView.addArrangedSubview(moodImage)
        
        return stackView
    }()
    
    // right stack with time feeling and reasons
    
    private lazy var timeFeelingReasonsStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(moodDescription)
        stackView.addArrangedSubview(reasonsDescription)

        return stackView
    }()
    
    private lazy var dayLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: CustomFont.kyivTypeSansBold3.rawValue, size: 30)
        
        return label
    }()
    
    private lazy var monthLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: CustomFont.kyivTypeSansBold3.rawValue, size: 30)
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: CustomFont.kyivTypeSansRegular2.rawValue, size: 14)
        
        return label
    }()
    
    private lazy var moodDescription: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: CustomFont.kyivTypeSansRegular2.rawValue, size: 22)
        
        return label
    }()
    
    private lazy var reasonsDescription: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: CustomFont.InterLight.rawValue, size: 14)
        
        return label
    }()
    
    private lazy var moodImage: UIImageView = {
        var imageView = UIImageView()
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var backgroundImage: UIImageView = {
        var imageView = UIImageView()
        
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupMainStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMainStackView() {
        contentView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14)
        ])
    }
    
    func set(note: MoodNote) {
        backgroundImage.image = note.backGroundImage
        dayLabel.text = note.day
        timeLabel.text = note.time
        moodImage.image = note.mood
        monthLabel.text = note.month
        moodDescription.text = note.moodDescription
        reasonsDescription.text = note.reasonsDescription
    }
    
}
