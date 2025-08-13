//
//  GFAlertViewViewController.swift
//  GitHFollowers
//
//  Created by Melih Bey on 26.05.2025.
//

import UIKit

class GFAlertVC: UIViewController {
    
    let containerView = GFAlertContainerView()
    
    let imageView = UIImageView()
    let titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = GFBodyLabel(textAlignment: .center)
    let actionButton = GFButton(color: .systemPink, title: "Ok", systemImageName: "checkmark.circle")
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    var action: (() -> Void)?
    var image: UIImage?
    
    let padding: CGFloat = 20
    
    init(alertTitle: String? = nil, message: String, buttonTitle: String, action: (() -> Void)? = nil, image: UIImage? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
        self.alertTitle = alertTitle
        self.message = message
        self.buttonTitle = buttonTitle
        self.action = action
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addSubViews(containerView, titleLabel, actionButton, messageLabel, imageView)
        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureMessageLabel()
        configureImageView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleBackgroundTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !containerView.frame.contains(location) {
            dismiss(animated: true)
        }
    }
    
    func configureContainerView() {
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280)
        ])
    }
    
    func configureImageView() {
        imageView.image = image
        imageView.tintColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureTitleLabel() {
        if let alertTitle = alertTitle {
            titleLabel.text = alertTitle
        }
        
        if image != nil {
            NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
            ])
        } else {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
                titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
                titleLabel.heightAnchor.constraint(equalToConstant: 28)
            ])
        }
        
    }
    
    func configureActionButton() {
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        if action != nil || image != nil {
            actionButton.configuration?.baseBackgroundColor = .systemBlue
            actionButton.configuration?.baseForegroundColor = .systemBlue
            actionButton.configuration?.image = action != nil ? SFSymbols.safari : SFSymbols.checkMark
        }
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configureMessageLabel() {
        messageLabel.text = message ?? "Unable to complete request"
        messageLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
        action?()
    }
 
}
