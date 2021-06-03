//
//  DataStorage.swift
//  Hw1
//
//  Created by Nikita on 15.04.2021.
//

import Foundation
import UIKit


class DataStorage: NSObject {
    static let shared = DataStorage()
    private override init(){
        super.init()
    }
    
    
    var usersArray = [User]()
    var friendsArray = [User]()
    
    
    var groupsArray = [Group]()
    var favoriteGroupsArray = [Group]()
    
    var newsArray = [News]()
}
