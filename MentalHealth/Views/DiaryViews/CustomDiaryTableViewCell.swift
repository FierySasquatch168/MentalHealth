//
//  CustomDiaryTableViewCell.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

class CustomDiaryTableViewCell: UITableViewCell {
    
    // MARK: StackViews
    // main stack of the cell
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 14
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.addArrangedSubview(dateStackView)
        stackView.addArrangedSubview(moodDescriptionStackView)
        
        return stackView
    }()
    
    // left stack with day and month
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(monthLabel)
                
        return stackView
    }()
    
    // right upper stack with moodImage and time/feeling/reasons
    
    private lazy var moodDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.addArrangedSubview(moodImageStackView)
        stackView.addArrangedSubview(timeFeelingReasonsStackView)
        
        return stackView
    }()
    
    // moodImage of the right stackView
    
    private lazy var moodImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.addArrangedSubview(moodImage)
        moodImage.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 15).isActive = true
        
        return stackView
    }()
    
    // right stack with time feeling and reasons
    
    private lazy var timeFeelingReasonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(moodDescription)
        stackView.addArrangedSubview(reasonsDescription)

        return stackView
    }()
    
    // MARK: Stackviews' content
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: CustomFont.kyivTypeSansBold3.rawValue, size: 30)
        label.textColor = .customDate
        
        return label
    }()
    
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: CustomFont.kyivTypeSansBold3.rawValue, size: 20)
        label.textColor = .customDate
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: CustomFont.kyivTypeSansRegular2.rawValue, size: 14)
        
        return label
    }()
    
    private lazy var moodDescription: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: CustomFont.kyivTypeSansRegular2.rawValue, size: 22)
        
        return label
    }()
    
    private lazy var reasonsDescription: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: CustomFont.InterLight.rawValue, size: 14)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var moodImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupMainStackView()
        setupBackgroundImage()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Change the time model for better sorting
    func set(note: MoodNote) {
        backgroundImage.image = note.backgroundImage
        dayLabel.text = note.day
        timeLabel.text = note.time
        moodImage.image = note.mood
        monthLabel.text = note.month
        moodDescription.text = note.moodDescription
        reasonsDescription.text = note.reasonsDescription
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
    
    private func setupBackgroundImage() {
        contentView.addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: moodDescriptionStackView.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: moodDescriptionStackView.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: moodDescriptionStackView.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: moodDescriptionStackView.bottomAnchor)
        ])
        
        
    }
}
