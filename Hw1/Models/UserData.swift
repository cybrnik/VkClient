//
//  UserData.swift
//  Hw1
//
//  Created by Nikita on 24.06.2021.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let userData = try? newJSONDecoder().decode(UserData.self, from: jsonData)

import Foundation

// MARK: - UserData
struct UserData: Codable {
    let response: [UserResponse]
}

// MARK: - Response
struct UserResponse: Codable {
    let firstName: String
    let id: Int
    let lastName: String
    let canAccessClosed, isClosed: Bool

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case canAccessClosed = "can_access_closed"
        case isClosed = "is_closed"
    }
}
