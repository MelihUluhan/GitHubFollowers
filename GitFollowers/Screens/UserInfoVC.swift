//
//  UserInfoVC.swift
//  GitFollowers
//
//  Created by Melih Bey on 28.05.2025.
//

import UIKit


protocol UserInfoVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class UserInfoVC: GFDataLoadingVC {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let profileButton = GFButton()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    var githubProfileURL: String?
    var itemViews: [UIView] = []
    
    var username: String!
    weak var delegate : UserInfoVCDelegate!
    
    init(username: String, delegate: UserInfoVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        getUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .systemPink
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.close, style: .plain, target: self, action: #selector(dismissVC))
    }
    
    func getUserInfo() {
        Task {
            showLoadingView()
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                configureUIElements(with: user)
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(title: "Something went wrong",
                                   message: gfError.rawValue,
                                   buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
            }
            dismissLoadingView()
        }
        
        //        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
        //            guard let self = self else { return }
        //            switch result {
        //                case .success(let user):
        //                    DispatchQueue.main.async { self.configureUIElements(with: user) }
        //                case .failure(let error):
        //                    self.presentGFAlert(title: "Something went wrong",
        //                                                    message: error.rawValue,
        //                                                    buttonTitle: "Ok")
        //            }
        //        }
    }
    
    func configureUIElements(with user: User) {
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: GFRepoItemVC(user: user, delegate: self), to: self.itemViewOne)
        self.add(childVC: GFFollowerItemVC(user: user, delegate: self), to: self.itemViewTwo)
        githubProfileURL = user.htmlUrl
        self.profileButton.set(color: .systemBlue, title: "Github Profile", systemImageName: "safari")
        self.profileButton.addTarget(self, action: #selector(openGitHubProfile), for: .touchUpInside)
        self.dateLabel.text = "Github since \(user.createdAt.convertToMonthYearFormat())"
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel, profileButton]
        
        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            profileButton.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            profileButton.heightAnchor.constraint(equalToConstant: 44),
            
            dateLabel.topAnchor.constraint(equalTo: profileButton.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc func openGitHubProfile() {
        presentGFAlert(title: username,
                       message: "Do you want to open the GitHub profile of \(username!) in Safari?",
                       buttonTitle: "Yes") {
            if let url = self.githubProfileURL {
                guard let url = URL(string: url) else {
                    self.presentGFAlert(title: "Invalid URL",
                                        message: "The URL attached to this user is invalid",
                                        buttonTitle: "Ok")
                    return
                }
                
                self.presentSafariVC(with: url)
            }
            
        }
    }
    
}

extension UserInfoVC: GFRepoItemVCDelegate {
    func didTapRepositories(for user: User) {
        let destVC = RepositoriesVC(username: user.login)
        navigationController?.pushViewController(destVC, animated: true)
        
    }
}

extension UserInfoVC: GFFollowerItemVCDelegate {
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGFAlert(title: "No followers",
                           message: "This user has no followers.",
                           buttonTitle: "Sad🫤")
            return
        }
        delegate.didRequestFollowers(for: user.login)
        dismissVC()
    }
}

