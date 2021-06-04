//
//  Session.swift
//  Hw1
//
//  Created by Nikita on 03.06.2021.
//

import Foundation

class Session {
    private init() {}
    static let shared = Session()
    var token: String = ""
    var userId: Int = 0
}
