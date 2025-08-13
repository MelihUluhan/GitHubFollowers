//
//  RepositoriesVC.swift
//  GitFollowers
//
//  Created by Melih Bey on 12.06.2025.
//

import UIKit

enum SortField {
    case created, updated
}

class RepositoriesVC: GFDataLoadingVC {
    
    var username: String!
    
    let stackView = UIStackView()
    let tableView = UITableView()
    var repositories: [Repositories] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRightNavigationBarButton()
        configureViewController()
        configureTableView()
    }
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .systemGreen
        getRepositories()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Repositories"
    }
    
    func configureRightNavigationBarButton() {
        let closeButton = UIButton(type: .system)
        closeButton.setImage(SFSymbols.close, for: .normal)
        closeButton.tintColor = .systemPink
        closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)

        let filterButton = UIButton(type: .system)
        filterButton.setImage(SFSymbols.filter, for: .normal)
        filterButton.tintColor = .systemGreen
        filterButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)

        let infoButton = UIButton(type: .system)
        infoButton.setImage(SFSymbols.info, for: .normal)
        infoButton.tintColor = .systemBlue
        infoButton.addTarget(self, action: #selector(infoTapped), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [infoButton, filterButton, closeButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.alignment = .center

        let barButton = UIBarButtonItem(customView: stackView)
        navigationItem.rightBarButtonItem = barButton
    }


    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.contentInset.bottom = 50
        tableView.rowHeight = 180
        tableView.separatorColor = .lightGray
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.removeExcessCells()
        
        tableView.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.reuseID)
    }
    
    func getRepositories() {
        Task {
            showLoadingView()
            do {
                let response = try await NetworkManager.shared.getUserRepos(for: username!)
                updateUI(with: response)
            } catch {
                if let error = error as? GFError {
                    presentGFAlert(title: "Something went wrong",
                                   message: error.rawValue,
                                   buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
            }
            dismissLoadingView()
        }
    }
    
    func updateUI(with repositories: [Repositories]) {
        if repositories.isEmpty {
            showEmptyStateView(with: "No Repositories found 🫤 ", in: self.view)
        } else {
            self.repositories = repositories
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
    
    
    
}

extension RepositoriesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.reuseID) as! RepositoryCell
        let repository = repositories[indexPath.row]
        cell.set(repo: repository)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRepo = repositories[indexPath.row]
        presentGFAlert(title: selectedRepo.fullName,
                       message: "Do you want to open this repository in Safari?",
                       buttonTitle: "Yes") {
            guard let url = URL(string: selectedRepo.htmlUrl) else {
                self.presentGFAlert(title: "Invalid URL",
                                    message: "The URL attached to this user is invalid",
                                    buttonTitle: "Ok")
                return
            }
            self.presentSafariVC(with: url)
        }
    }
    
}

extension RepositoriesVC {
    @objc func filterTapped() {
        let alert = UIAlertController(title: "Sort Repositories", message: "Choose a filter option", preferredStyle: .actionSheet)
        
        let green = UIColor.systemGreen
        let red = UIColor.systemPink

        let createdAsc = UIAlertAction(title: "Created Date ↑", style: .default) { _ in
            self.sortRepositories(by: .created, ascending: true)
        }
        createdAsc.setValue(green, forKey: "titleTextColor")

        let createdDesc = UIAlertAction(title: "Created Date ↓", style: .default) { _ in
            self.sortRepositories(by: .created, ascending: false)
        }
        createdDesc.setValue(green, forKey: "titleTextColor")

        let updatedAsc = UIAlertAction(title: "Updated Date ↑", style: .default) { _ in
            self.sortRepositories(by: .updated, ascending: true)
        }
        updatedAsc.setValue(green, forKey: "titleTextColor")

        let updatedDesc = UIAlertAction(title: "Updated Date ↓", style: .default) { _ in
            self.sortRepositories(by: .updated, ascending: false)
        }
        updatedDesc.setValue(green, forKey: "titleTextColor")

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        cancel.setValue(red, forKey: "titleTextColor")

        alert.addAction(createdAsc)
        alert.addAction(createdDesc)
        alert.addAction(updatedAsc)
        alert.addAction(updatedDesc)
        alert.addAction(cancel)

        present(alert, animated: true)
    }
    
    func sortRepositories(by field: SortField, ascending: Bool) {
        switch field {
            case .created:
                repositories.sort {
                    ascending ? $0.createdAt < $1.createdAt : $0.createdAt > $1.createdAt
                }
            case .updated:
                repositories.sort {
                    ascending ? $0.updatedAt < $1.updatedAt : $0.updatedAt > $1.updatedAt
                }
        }
        tableView.reloadData()
    }
    
    @objc func infoTapped() {
        presentGFAlert(message: "If you want to see repositories details, you can tap on any repository. That will open a safari view controller with more information about that repository.", buttonTitle: "Ok", image: SFSymbols.info)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
