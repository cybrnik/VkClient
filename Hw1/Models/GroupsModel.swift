//
//  GroupsModel.swift
//  Hw1
//
//  Created by Nikita on 04.06.2021.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let groups = try? newJSONDecoder().decode(Groups.self, from: jsonData)

import Foundation

// MARK: - Groups
struct Groups: Codable {
    let response: ResponseGroup
}


// MARK: - Response
struct ResponseGroup: Codable {
    let count: Int
    let items: [ItemGroup]
}

// MARK: - Item
struct ItemGroup: Codable {
    let id: Int
    let name, screenName: String
    let isClosed: Int
    let type: TypeEnum
    let isAdmin, isMember, isAdvertiser: Int
    let itemDescription: String?
    let photo200: String
    let adminLevel: Int?
    let deactivated: String?
    let activity: String?
    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case itemDescription = "description"
        case photo200 = "photo_200"
        case adminLevel = "admin_level"
        case deactivated
        case activity
    }
}

enum TypeEnum: String, Codable {
    case group = "group"
    case page = "page"
}
