//
//  RepositoryCell.swift
//  GitFollowers
//
//  Created by Melih Bey on 13.06.2025.
//

import UIKit

class RepositoryCell: UITableViewCell {
    static let reuseID = "RepositoryCell"
    
    let repoName = GFTitleLabel(textAlignment: .left, fontSize: 20)
    let repoDescription = UILabel()
    let privateLabel = UIButton()
    let repoInfo = GFRepoInfoView()
    let dateTableView = GFDateTableView()
    
    private let verticalPadding: CGFloat = 8
    private let horizontalPadding: CGFloat = 12
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        configureLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(repo: Repositories) {
        repoName.text = "📂 \(repo.name)"
        repoDescription.text = "📝 \(repo.description ?? "There is no description...")"
        
        let isPrivate = repo.private
        let titleText = isPrivate ? "🔒 Private" : "🔑 Public"
        let color = isPrivate ? UIColor.systemRed : UIColor.systemGreen
        
        var attrTitle = AttributedString(titleText)
        attrTitle.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        privateLabel.configuration?.attributedTitle = attrTitle
        privateLabel.configuration?.baseBackgroundColor = color
        privateLabel.configuration?.baseForegroundColor = color
        
        dateTableView.setDates(created: repo.createdAt, updated: repo.updatedAt)
        repoInfo.set(repo: repo)
    }
    
    private func configureViews() {
        addSubViews(repoName,repoDescription,privateLabel, repoInfo, dateTableView)
        
        repoName.translatesAutoresizingMaskIntoConstraints = false
        repoDescription.translatesAutoresizingMaskIntoConstraints = false
        privateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        privateLabel.configuration = .tinted()
        privateLabel.configuration?.cornerStyle = .small
        privateLabel.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6)
    }
    
    private func configureLayouts() {
        NSLayoutConstraint.activate([
            repoName.topAnchor.constraint(equalTo: topAnchor, constant: verticalPadding),
            repoName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            repoName.trailingAnchor.constraint(equalTo: privateLabel.leadingAnchor, constant: -horizontalPadding),
            
            repoDescription.topAnchor.constraint(equalTo: repoName.bottomAnchor, constant: 4),
            repoDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            repoDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
            
            privateLabel.centerYAnchor.constraint(equalTo: repoName.centerYAnchor),
            privateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
            privateLabel.widthAnchor.constraint(equalToConstant: 80),
            
            dateTableView.topAnchor.constraint(equalTo: repoDescription.bottomAnchor, constant: 8),
            dateTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            dateTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
            dateTableView.heightAnchor.constraint(equalToConstant: 70),
            
            repoInfo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalPadding),
            repoInfo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding * 2),
            repoInfo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding * 2)
        ])
    }
    
}

