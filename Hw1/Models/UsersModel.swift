//
//  Users.swift
//  Hw1
//
//  Created by Nikita on 03.06.2021.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let users = try? newJSONDecoder().decode(Users.self, from: jsonData)

import Foundation

// MARK: - Users
struct Users: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let count: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let firstName: String
    let id: Int
    let lastName: String
    let canAccessClosed, isClosed: Bool?
    let photo200_Orig: String
    let trackCode: String
    let lists: [Int]?
    let deactivated: Deactivated?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case canAccessClosed = "can_access_closed"
        case isClosed = "is_closed"
        case photo200_Orig = "photo_200_orig"
        case trackCode = "track_code"
        case lists, deactivated
    }
}

enum Deactivated: String, Codable {
    case banned = "banned"
    case deleted = "deleted"
}
