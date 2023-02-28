//
//  ReadNoteViewController.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 27.02.2023.
//

import UIKit

final class ReadNoteViewController: UIViewController {
    
    var moodNote: MoodNote?
    
    private var textViewBorderWidth: CGFloat = 1
    private var moodNoteCornerRadius: CGFloat = 29
    
//    private var dayFontSize: CGFloat = 30
//    private var monthFontSize: CGFloat = 20
//    private var timeFontSize: CGFloat = 14
//    private var moodFontSize: CGFloat = 22
//    private var reasonsFontSize: CGFloat = 14
//    private var noteFontSize: CGFloat = 14
    
    private lazy var dismissButton: CustomDismissButton = {
        let button = CustomDismissButton()
        button.addTarget(self, action: #selector(dismissToPreviousScreen), for: .touchUpInside)
        return button
    }()
    
    private lazy var dateLabel: UITextView = {
        let textView = UITextView()
        textView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        if let day = moodNote?.day, let month = moodNote?.month, let time = moodNote?.time {
            let string = "\(day) \(month)\n\(time)"
            let attributedString = NSMutableAttributedString(string: string)
            
            attributedString.addAttribute(.font,
                                          value: UIFont(name: CustomFont.kyivTypeSansBold3.rawValue, size: 30)!,
                                          range: NSRange(location: 0, length: day.count))
            
            attributedString.addAttribute(.font,
                                          value: UIFont(name: CustomFont.kyivTypeSansBold3.rawValue, size: 20)!,
                                          range: NSRange(location: day.count + 1, length: month.count))
            
            attributedString.addAttribute(.foregroundColor,
                                          value: UIColor.customDate!,
                                          range: NSRange(location: 0, length: day.count + month.count + 1))
            
            attributedString.addAttribute(.font,
                                          value: UIFont(name: CustomFont.kyivTypeSansRegular2.rawValue, size: 14)!,
                                          range: NSRange(location: day.count + month.count + 2, length: time.count))
            
            attributedString.addAttribute(.foregroundColor,
                                          value: UIColor.customTextViewTextColor!,
                                          range: NSRange(location: day.count + month.count + 2, length: time.count))
            
            let alignment = NSMutableParagraphStyle()
            alignment.alignment = NSTextAlignment.center
            
            attributedString.addAttribute(.paragraphStyle,
                                          value: alignment,
                                          range: NSRange(location: 0, length: string.count))
            
            textView.attributedText = attributedString
        } else {
            print("dateLabel error")
        }
        
        return textView
    }()
    
    private lazy var mood: UIImageView = {
        let imageView = UIImageView()
        guard let moodImage = moodNote?.mood else { return imageView }
        imageView.image = moodImage
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 72.5
        return imageView
    }()
    
    private lazy var moodDescription: UITextView = {
        let textView = UITextView()
        let color = moodNote?.moodDescription == "Happy" ? UIColor.customHappy : UIColor.customResentmentBackground
        textView.backgroundColor = color
        textView.layer.cornerRadius = moodNoteCornerRadius
        textView.textContainerInset.top = 45
        
        if let title = moodNote?.moodDescription?.uppercased(), let subtitle = moodNote?.reasonsDescription?.lowercased() {
            let string = "\(title)\n\(subtitle)"
            let attributedString = NSMutableAttributedString(string: string)
            
            attributedString.addAttribute(.font,
                                          value: UIFont(name: CustomFont.kyivTypeSansRegular2.rawValue, size: 22)!,
                                          range: NSRange(location: 0, length: title.count))
            
            attributedString.addAttribute(.font,
                                          value: UIFont(name: CustomFont.InterLight.rawValue, size: 14)!,
                                          range: NSRange(location: title.count + 1, length: subtitle.count))
            
            attributedString.addAttribute(.foregroundColor,
                                          value: UIColor.customChartButton!,
                                          range: NSRange(location: title.count + 1, length: subtitle.count))
            
            let alignment = NSMutableParagraphStyle()
            alignment.alignment = NSTextAlignment.center
            
            attributedString.addAttribute(.paragraphStyle,
                                          value: alignment,
                                          range: NSRange(location: 0, length: string.count))
                        
            textView.attributedText = attributedString
        }
        
        return textView
    }()
    
    private lazy var note: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = moodNoteCornerRadius
        textView.layer.borderWidth = textViewBorderWidth
        let borderColor = moodNote?.moodDescription == "Happy" ? UIColor.customHappy?.cgColor : UIColor.customResentmentBackground?.cgColor
        textView.layer.borderColor = borderColor
        textView.textContainerInset.top = 141
        textView.textContainerInset.left = 20
        textView.textContainerInset.right = 20
        textView.textContainerInset.bottom = 20
        textView.textColor = .customTextViewTextColor
        guard let note = moodNote?.note else {
            print("note error")
            textView.text = "No text was added here"
            return textView
        }
        textView.text = moodNote?.note
        textView.font = UIFont(name: CustomFont.InterLight.rawValue, size: 14)
        print("no note error")
        return textView
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    // MARK: Behavior
    
    @objc private func dismissToPreviousScreen() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func setupUI() {
        setupDateLabel()
        setupNote()
        setupMoodDescription()
        setupMoodImage()
        setupDismissButton()
    }
}

// MARK: Extension Constraints

extension ReadNoteViewController {
    private func setupDateLabel() {
        view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 49),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 131),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -131),
            dateLabel.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
    
    private func setupMoodImage() {
        view.addSubview(mood)
        mood.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mood.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 14),
            mood.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mood.heightAnchor.constraint(equalToConstant: 145),
            mood.widthAnchor.constraint(equalToConstant: 145)
        ])
    }
    
    private func setupMoodDescription() {
        view.addSubview(moodDescription)
        moodDescription.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            moodDescription.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 248),
            moodDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            moodDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            moodDescription.heightAnchor.constraint(equalToConstant: 129)
        ])
    }
    
    private func setupNote() {
        view.addSubview(note)
        note.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            note.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 248),
            note.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            note.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            note.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -123)
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
