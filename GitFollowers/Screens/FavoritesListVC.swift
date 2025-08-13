//
//  FavoritesListVC.swift
//  GitHFollowers
//
//  Created by Melih Bey on 26.05.2025.
//

import UIKit

class FavoritesListVC: GFDataLoadingVC {
    
    let tableView = UITableView()
    var favorites: [Follower] = []
    var filteredFavorites: [Follower] = []
    var isSearching: Bool = false
    
    weak var delegate : UserInfoVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemGreen
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a favorites"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
    
    func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let favorites):
                    self.updateUI(with: favorites)
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.presentGFAlert(title: "Something went wrong...",
                                                        message: error.rawValue,
                                                        buttonTitle: "Ok")
                    }
            }
        }
    }
    
    func updateUI(with favorites: [Follower]) {
        DispatchQueue.main.async {
            if favorites.isEmpty {
                self.showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen.", in: self.view)
            } else {
                self.favorites = favorites
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }

}

extension FavoritesListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredFavorites.count : favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        let activeArray = isSearching ? filteredFavorites : favorites

        let favorite = activeArray[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFavorites : favorites
  
        let destVC = UserInfoVC(username: activeArray[indexPath.row].login, delegate: self)
        present(UINavigationController(rootViewController: destVC), animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        PersistenceManager.updateWith(favorite: favorites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                return
            }
            DispatchQueue.main.async {
                self.presentGFAlert(title: "Unable to remove",
                                    message: error.rawValue,
                                    buttonTitle: "Ok")
            }
        }
    }
    
}

extension FavoritesListVC: UserInfoVCDelegate {
    func didRequestFollowers(for username: String) {
        let followerListVC = FollowerListVC(username: username)
        navigationController?.pushViewController(followerListVC, animated: true)
    }
}

extension FavoritesListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFavorites.removeAll()
            updateUI(with: favorites)
            isSearching = false
            return
        }
        isSearching = true
        filteredFavorites = favorites.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateUI(with: favorites)
    }
}
