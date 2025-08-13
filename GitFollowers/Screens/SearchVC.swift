//
//  SearchVC.swift
//  GitHFollowers
//
//  Created by Melih Bey on 26.05.2025.
//

import UIKit

class SearchVC: UIViewController {
    
    let logoImageView = UIImageView()
    let userNameTF = GFTextField()
    let getProfileInfoButton = GFButton(color: .systemGreen, title: "GitHub Profile", systemImageName: "person")
    
    var isUsernameEntered: Bool { return !userNameTF.text!.isEmpty }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureGetProfileInfoButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameTF.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushUserInfoVC() {
        guard isUsernameEntered else {
            presentGFAlert(title: "Empty Username",
                           message: "Please enter a username. We need to know who to looking for!",
                           buttonTitle: "Ok")
            return
        }
        
        userNameTF.resignFirstResponder()
        let username = userNameTF.text ?? "-"
        
        let destVC = UserInfoVC(username: username, delegate: self)
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }

    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureTextField() {
        view.addSubview(userNameTF)
        userNameTF.delegate = self
        
        NSLayoutConstraint.activate([
            userNameTF.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            userNameTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userNameTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            userNameTF.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureGetProfileInfoButton() {
        view.addSubview(getProfileInfoButton)
        getProfileInfoButton.addTarget(self, action: #selector(pushUserInfoVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            getProfileInfoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            getProfileInfoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            getProfileInfoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            getProfileInfoButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushUserInfoVC()
        return true
    }
}

extension SearchVC: UserInfoVCDelegate {
    func didRequestFollowers(for username: String) {
        let followerListVC = FollowerListVC(username: username)
        navigationController?.pushViewController(followerListVC, animated: true)
    }
}
