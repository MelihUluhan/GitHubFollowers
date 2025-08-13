//
//  GFDateTableView.swift
//  GitFollowers
//
//  Created by Melih Bey on 16.06.2025.
//

import UIKit

class GFDateTableView: UIView {
    
    let createdTitleLabel = GFSecondaryTitleLabel(fontSize: 14)
    let createdValueLabel = GFSecondaryTitleLabel(fontSize: 14)
    
    let updatedTitleLabel = GFSecondaryTitleLabel(fontSize: 14)
    let updatedValueLabel = GFSecondaryTitleLabel(fontSize: 14)
    
    let separator = UIView()
    
    private let horizontalPadding: CGFloat = 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        configureLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setDates(created: Date, updated: Date) {
        createdValueLabel.text = created.convertToddMMMyyyy()
        updatedValueLabel.text = updated.convertToddMMMyyyy()
    }
    
    private func configureViews() {
        addSubViews(createdTitleLabel, createdValueLabel, updatedTitleLabel, updatedValueLabel, separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        createdTitleLabel.text = "Created date"
        createdTitleLabel.textAlignment = .left
        createdValueLabel.textAlignment = .left
        
        updatedTitleLabel.text = "Updated date"
        updatedTitleLabel.textAlignment = .right
        updatedValueLabel.textAlignment = .right
        
        separator.backgroundColor = .lightGray
    }
    
    private func configureLayouts() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createdTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            createdTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            createdTitleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            createdTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            updatedTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            updatedTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
            updatedTitleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            updatedTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            separator.topAnchor.constraint(equalTo: createdTitleLabel.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            createdValueLabel.topAnchor.constraint(equalTo: separator.bottomAnchor),
            createdValueLabel.leadingAnchor.constraint(equalTo: createdTitleLabel.leadingAnchor),
            createdValueLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            createdValueLabel.heightAnchor.constraint(equalToConstant: 30),
            
            updatedValueLabel.topAnchor.constraint(equalTo: separator.bottomAnchor),
            updatedValueLabel.trailingAnchor.constraint(equalTo: updatedTitleLabel.trailingAnchor),
            updatedValueLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            updatedValueLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

}
