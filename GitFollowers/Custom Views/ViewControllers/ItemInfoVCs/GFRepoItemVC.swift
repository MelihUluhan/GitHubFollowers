//
//  GFRepoItemVC.swift
//  GitFollowers
//
//  Created by Melih Bey on 2.06.2025.
//

import UIKit

protocol GFRepoItemVCDelegate: AnyObject {
    func didTapRepositories(for user: User)
}

class GFRepoItemVC: GFItemInfoVC {
    
    weak var delegate: GFRepoItemVCDelegate!
    
    init(user:User, delegate: GFRepoItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(color: .systemPurple, title: "Get Repositories", systemImageName: "folder.badge.questionmark")
    }
    
    override func actionButtonTapped() {
        delegate.didTapRepositories(for: user)
    }
}
