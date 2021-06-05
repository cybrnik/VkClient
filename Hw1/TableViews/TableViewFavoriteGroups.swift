//
//  TableViewFavoriteGroups.swift
//  Hw1
//
//  Created by Nikita on 15.04.2021.
//

import UIKit

class TableViewFavoriteGroups: UIViewController, UISearchBarDelegate  {
    

    var filteredArray = DataStorage.shared.favoriteGroupsArray
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    var refreshControl = UIRefreshControl()
    override func viewWillAppear(_ animated: Bool) {
        filteredArray = []
        if searchBar.text == "" {
            filteredArray = DataStorage.shared.favoriteGroupsArray
        }
        else {
            for item in DataStorage.shared.favoriteGroupsArray{
                if item.name.lowercased().contains(searchBar.text?.lowercased() ??  ""){
                    filteredArray.append(item)
                }
            }
        }
        super.viewWillAppear(animated)
        myTableView.reloadData()
    }
    func sortAndGetSections() -> [(letter: Character, names: [String])] {
        filteredArray.sort { (lhs: Group, rhs: Group) -> Bool in
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
            filteredArray = DataStorage.shared.favoriteGroupsArray
        }
        else {
            for item in DataStorage.shared.favoriteGroupsArray{
                if item.name.lowercased().contains(searchBar.text?.lowercased() ??  ""){
                    filteredArray.append(item)
                }
            }
        }
        super.viewDidLoad()
        searchBar.delegate = self
        myTableView.dataSource = self
        myTableView.delegate = self
        self.showSpinner()
        VkApi().VKgetGroups (finished: {
            
            self.filteredArray = []
            if self.searchBar.text == "" {
                self.filteredArray = DataStorage.shared.favoriteGroupsArray
            }
            else {
                for item in DataStorage.shared.favoriteGroupsArray {
                    if item.name.lowercased().contains(self.searchBar.text?.lowercased() ??  ""){
                        self.filteredArray.append(item)
                    }
                }
            }
            self.myTableView.reloadData()
            self.removeSpinner()
        })
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        myTableView.addSubview(refreshControl) // not required when using UITableViewController
        
        let nibFile = UINib(nibName: "CustomTableViewCell", bundle: nil)
        
        myTableView.register(nibFile, forCellReuseIdentifier: "CustomTableViewCell")
        myTableView.reloadData()
    }
    @objc func refresh(_ sender: AnyObject) {
        self.showSpinner()
        VkApi().VKgetGroups (finished: {
            
            self.filteredArray = []
            if self.searchBar.text == "" {
                self.filteredArray = DataStorage.shared.favoriteGroupsArray
            }
            else {
                for item in DataStorage.shared.favoriteGroupsArray{
                    if item.name.lowercased().contains(self.searchBar.text?.lowercased() ??  ""){
                        self.filteredArray.append(item)
                    }
                }
            }
            

            self.myTableView.reloadData()
            self.removeSpinner()
        })

        refreshControl.endRefreshing()
    }
    
}
extension TableViewFavoriteGroups: UITableViewDataSource {
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
        
        cell.configure(title: filteredArray[iStruct+indexPath.row].name, description: filteredArray[iStruct+indexPath.row].description, image: filteredArray[iStruct+indexPath.row].mainPhoto)
        
        return cell
        
    }
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String){

        filteredArray = []
        if searchText == "" {
            filteredArray = DataStorage.shared.favoriteGroupsArray
        }
        else {
            for item in DataStorage.shared.favoriteGroupsArray{
                if item.name.lowercased().contains(searchText.lowercased()){
                    filteredArray.append(item)
                }
            }
        }
        myTableView.reloadData()
    }


}
extension TableViewFavoriteGroups: UITableViewDelegate{

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
        let contextItem = UIContextualAction(style: .destructive, title: "Удалить") { [self]  (contextualAction, view, boolValue) in
            for (index,item) in DataStorage.shared.favoriteGroupsArray.enumerated() {
                if item.id == filteredArray[iStruct+indexPath.row].id {
                    let user = DataStorage.shared.favoriteGroupsArray[index]
                    DataStorage.shared.favoriteGroupsArray.remove(at: index)
                    DataStorage.shared.groupsArray.append(user)
                    filteredArray = []
                    if searchBar.text == "" {
                        filteredArray = DataStorage.shared.favoriteGroupsArray
                    }
                    else {
                        for item in DataStorage.shared.favoriteGroupsArray{
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
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }


}


fileprivate var aView: UIView?
extension TableViewFavoriteGroups {
    
    func showSpinner() {
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = aView!.center
        ai.startAnimating()

        aView?.addSubview(ai)
        self.view.addSubview(aView!)
        
        
    }
    
    func removeSpinner(){
        aView!.removeFromSuperview()
        aView = nil
    }
}
