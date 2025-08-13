//
//  UIView+Ext.swift
//  GitFollowers
//
//  Created by Melih Bey on 11.06.2025.
//

import UIKit

extension UIView {
    func addSubViews(_ subViews: UIView...) {
        subViews.forEach { addSubview($0) }
    }
}
