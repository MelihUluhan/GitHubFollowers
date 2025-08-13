//
//  UITableView+Ext.swift
//  GitFollowers
//
//  Created by Melih Bey on 11.06.2025.
//

import UIKit

extension UITableView {
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
