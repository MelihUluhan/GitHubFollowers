//
//  UIViewController+Ext.swift
//  GitHFollowers
//
//  Created by Melih Bey on 27.05.2025.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func presentGFAlert(title: String? = nil, message: String, buttonTitle: String, action: (() -> Void)? = nil, image: UIImage? = nil) {
        let alertVC = GFAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle, action: action, image: image)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true)
    }
    
    func presentDefaultError() {
        let alertVC = GFAlertVC(alertTitle: "Something went wrong",
                                message: "We were unable to complete your task at this time. Please try again...",
                                buttonTitle: "Ok")
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true)
    }
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}
