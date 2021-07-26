

//
//  TableViewUsers.swift
//  Hw1
//
//  Created by Nikita on 15.04.2021.
//

import UIKit

class TableViewUsers: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    var photoService: PhotoService?
    var photo = UIImage(named: "unnamed")!
    var row = Int()
    var type = "Users"
    var filteredArray = DataStorage.shared.usersArray
    override func viewWillAppear(_ animated: Bool) {
        filteredArray = []
        if searchBar.text == "" {
            filteredArray = DataStorage.shared.usersArray
        }
        else {
            for item in DataStorage.shared.usersArray{
                if item.name.lowercased().contains(searchBar.text?.lowercased() ??  ""){
                    filteredArray.append(item)
                }
            }
        }
        super.viewWillAppear(animated)
        myTableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue,sender: Any?){
        if segue.identifier == "fromUsersToPhoto"{
            guard let dst = segue.destination as? PhotoCollectionView else {
                return
            }
            dst.photo = photo
            dst.type = type
            dst.row = row
        }
    }
    func sortAndGetSections() -> [(letter: Character, names: [String])] {
        filteredArray.sort { (lhs: User, rhs: User) -> Bool in
            return lhs.name < rhs.name
        }

        var users = [String]()
        for item in filteredArray{
            users.append(item.name)
        }
        let sections = Dictionary(grouping: users) { (country) -> Character in
            return country.first!
            }
            .map { (key: Character, value: [String]) -> (letter: Character, names: [String]) in
                (letter: key, names: value)
            }
            .sorted { (left, right) -> Bool in
                left.letter < right.letter
            }
        return sections
    }
    override func viewDidLoad() {
        filteredArray = []
        if searchBar.text == "" {
            filteredArray = DataStorage.shared.usersArray
        }
        else {
            for item in DataStorage.shared.usersArray{
                if item.name.lowercased().contains(searchBar.text?.lowercased() ??  ""){
                    filteredArray.append(item)
                }
            }
        }
        super.viewDidLoad()
        searchBar.delegate = self
        myTableView.dataSource = self
        
        let nibFile = UINib(nibName: "CustomTableViewCell", bundle: nil)
        
        myTableView.register(nibFile, forCellReuseIdentifier: "CustomTableViewCell")
        myTableView.reloadData()

    }


}
extension TableViewUsers: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        let sections = sortAndGetSections()
        return sections.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sections = sortAndGetSections()
        var returnKey = ""
        var i = 0
        for (key,_) in sections{
            if i == section{
                returnKey = String(key)
            }
            i+=1
        }
        
        return returnKey
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = sortAndGetSections()
        var i = 0
        for (_,names) in sections{
            if i == section{
                return names.count
            }
            i+=1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sections = sortAndGetSections()
        var i = 0
        var iStruct = 0

        for (_,names) in sections{
            if i == indexPath.section{
                break
            }else{
                iStruct += names.count
            }
            i+=1
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        cell.configure(title: filteredArray[iStruct+indexPath.row].name, description: filteredArray[iStruct+indexPath.row].status, image: filteredArray[iStruct+indexPath.row].mainPhoto)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sections = sortAndGetSections()
        var i = 0
        var iStruct = 0

        for (_,names) in sections{
            if i == indexPath.section{
                break
            }else{
                iStruct += names.count
            }
            i+=1
        }
        
        self.photo = filteredArray[iStruct+indexPath.row].mainPhoto ?? UIImage(named: "unnamed")!
        self.row = iStruct+indexPath.row
        for (index,item) in DataStorage.shared.usersArray.enumerated() {
            if item.id == filteredArray[iStruct+indexPath.row].id {
                self.row = index
            }
            
        }
        
        performSegue(withIdentifier: "fromUsersToPhoto", sender: nil)
    }
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String){
        filteredArray = []
        if searchText == "" {
            filteredArray = DataStorage.shared.usersArray
        }
        else {
            for item in DataStorage.shared.usersArray{
                if item.name.lowercased().contains(searchText.lowercased()){
                    filteredArray.append(item)
                }
            }
        }
        myTableView.reloadData()
    }
}
extension TableViewUsers: UITableViewDelegate{

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let sections = sortAndGetSections()
        var i = 0
        var iStruct = 0

        for (_,names) in sections{
            if i == indexPath.section{
                break
            }else{
                iStruct += names.count
            }
            i+=1
        }
        let contextItem = UIContextualAction(style: .destructive, title: "Добавить") { [self]  (contextualAction, view, boolValue) in
            for (index,item) in DataStorage.shared.usersArray.enumerated() {
                if item.id == filteredArray[iStruct+indexPath.row].id {
                    let user = DataStorage.shared.usersArray[index]
                    DataStorage.shared.usersArray.remove(at: index)
                    DataStorage.shared.friendsArray.append(user)
                    filteredArray = []
                    if searchBar.text == "" {
                        filteredArray = DataStorage.shared.usersArray
                    }
                    else {
                        for item in DataStorage.shared.usersArray{
                            if item.name.lowercased().contains(searchBar.text?.lowercased() ?? ""){
                                filteredArray.append(item)
                            }
                        }
                    }
                    myTableView.reloadData()
                    self.myTableView.reloadData()
                    break
                }
            }
        }
        contextItem.backgroundColor = .systemGreen
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }


}
