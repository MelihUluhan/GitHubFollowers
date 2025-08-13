//
//  GFRepoInfoView.swift
//  GitFollowers
//
//  Created by Melih Bey on 16.06.2025.
//

import UIKit

class GFRepoInfoView: UIView {
    
    let containerView = UIView()
    let stackView = UIStackView()
    let infoText1 = GFSecondaryTitleLabel(fontSize: 15)
    let infoText2 = GFSecondaryTitleLabel(fontSize: 15)
    let infoText3 = GFSecondaryTitleLabel(fontSize: 15)
    let infoText4 = GFSecondaryTitleLabel(fontSize: 15)
    
    private let verticalPadding: CGFloat = 8
    private let horizontalPadding: CGFloat = 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(repo: Repositories) {
        infoText1.text = ("⭐️\(String(repo.stargazersCount))")
        infoText2.text = ("👀\(String(repo.watchersCount))")
        infoText3.text = ("🐞\(String(repo.openIssuesCount))")
        infoText4.text = ("🍴\(String(repo.forksCount))")
    }
    
    private func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalPadding),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding * 2),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding * 2),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: verticalPadding),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -verticalPadding),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: horizontalPadding),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -horizontalPadding),
        ])
    }
    
    private func configureStackView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .systemGreen.withAlphaComponent(0.3)
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        
        stackView.addArrangedSubview(infoText1)
        stackView.addArrangedSubview(infoText2)
        stackView.addArrangedSubview(infoText3)
        stackView.addArrangedSubview(infoText4)
        
    }

}
