//
//  FollowerListVC.swift
//  GitHFollowers
//
//  Created by Melih Bey on 26.05.2025.
//

import UIKit

enum Section {
    case main
}

class FollowerListVC: GFDataLoadingVC {
    
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page: Int = 1
    var hasMoreFollowers: Bool = true
    var isSearching: Bool = false
    var isLoadingMoreFollowers: Bool = false
    
    var collectionView: UICollectionView!
    var dataSource : UICollectionViewDiffableDataSource<Section, Follower>!
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(userName: username, page: page)
        configureDataSource()
        configureSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemGreen
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    func getFollowers(userName:String, page:Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        Task {
            do {
                let followers = try await NetworkManager.shared.getFollowers(for: userName, page: page)
                updateUI(with: followers)
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(title: "Bad Stuff Happened",
                                                    message: gfError.rawValue,
                                                    buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
            }
            dismissLoadingView()
        }
        
        //        NetworkManager.shared.getFollowers(for: username, page: page) {[weak self] result in
        //            guard let self = self else { return }
        //            self.dismissLoadingView()
        //            switch result {
        //                case .success(let followers):
        //                    self.updateUI(with: followers)
        //
        //                case .failure(let error):
        //                    self.presentGFAlert(title: "Bad Stuff Happened",
        //                                                    message: error.rawValue,
        //                                                    buttonTitle: "Ok")
        //            }
        //        }
    }
    
    func updateUI(with followers: [Follower]) {
        if followers.count < 100 { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)
        
        if self.followers.isEmpty {
            DispatchQueue.main.async {
                self.showEmptyStateView(with: "This user doesnt have any followers. Go follow them.", in: self.view)
            }
            return
        }
        updateData(on: self.followers)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView,cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections( [.main] )
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
        isLoadingMoreFollowers = false
    }
    
    @objc func addButtonTapped() {
        showLoadingView()
        isLoadingMoreFollowers = true
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                addUserToFavorites(user: user)
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(title: "Something went wrong...",
                                   message: gfError.rawValue,
                                   buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
            }
        }
        dismissLoadingView()
//        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
//            guard let self = self else { return }
//            self.dismissLoadingView()
//            
//            switch result {
//                case .success(let user):
//                    self.addUserToFavorites(user: user)
//                    
//                case .failure(let error):
//                    self.presentGFAlert(title: "Something went wrong...",
//                                                    message: error.rawValue,
//                                                    buttonTitle: "Ok")
//            }
//            isLoadingMoreFollowers = false
//        }
    }
    
    func addUserToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) {[weak self] error in
            guard let self = self else { return }
            
            guard let error = error else {
                DispatchQueue.main.async {
                    self.presentGFAlert(title: "Success!",
                                                    message: "You have successfully favorited this user...🎊",
                                                    buttonTitle: "Ok")
                }
                return
            }
            DispatchQueue.main.async {
                self.presentGFAlert(title: "Something went wrong...",
                                                message: error.rawValue,
                                                buttonTitle: "Ok")
            }
        }
    }
}

extension FollowerListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(userName: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let destVC = UserInfoVC(username: follower.login, delegate: self)
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}

extension FollowerListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}

extension FollowerListVC: UserInfoVCDelegate {
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        followers.removeAll()
        filteredFollowers.removeAll()
        page = 1
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(userName: username, page: page)
    }
}
