//
//  Repositories.swift
//  GitFollowers
//
//  Created by Melih Bey on 12.06.2025.
//

import Foundation

struct Repositories: Codable {
    let name: String
    let fullName: String
    let description: String?
    let owner: Owner
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let createdAt: Date
    let updatedAt: Date
    let `private`: Bool
    let fork: Bool
    let archived: Bool
    let disabled: Bool
    let htmlUrl: String
    
    struct Owner: Codable {
        let login: String
        let avatarUrl: String?
        let htmlUrl: String
    }
}


