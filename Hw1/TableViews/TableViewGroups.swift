
//
//  TableViewGroups.swift
//  Hw1
//
//  Created by Nikita on 15.04.2021.
//

import UIKit

class TableViewGroups: UIViewController, UISearchBarDelegate {
    var filteredArray = DataStorage.shared.groupsArray
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var myTableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        filteredArray = []
        if searchBar.text == "" {
            filteredArray = DataStorage.shared.groupsArray
        } else {
            for item in DataStorage.shared.groupsArray {
                if item.name.lowercased().contains(searchBar.text?.lowercased() ?? "") {
                    filteredArray.append(item)
                }
            }
        }
        super.viewWillAppear(animated)
        myTableView.reloadData()
    }

    func sortAndGetSections() -> [(letter: Character, names: [String])] {
        filteredArray.sort { (lhs: Group, rhs: Group) -> Bool in
            lhs.name < rhs.name
        }

        var users = [String]()
        for item in filteredArray {
            users.append(item.name)
        }
        let sections = Dictionary(grouping: users) { country -> Character in
            country.first!
        }
        .map { (key: Character, value: [String]) -> (letter: Character, names: [String]) in
            (letter: key, names: value)
        }
        .sorted { left, right -> Bool in
            left.letter < right.letter
        }
        return sections
    }

    override func viewDidLoad() {
        filteredArray = []
        if searchBar.text == "" {
            filteredArray = DataStorage.shared.groupsArray
        } else {
            for item in DataStorage.shared.groupsArray {
                if item.name.lowercased().contains(searchBar.text?.lowercased() ?? "") {
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

extension TableViewGroups: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        let sections = sortAndGetSections()
        return sections.count
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sections = sortAndGetSections()
        var returnKey = ""
        var i = 0
        for (key, _) in sections {
            if i == section {
                returnKey = String(key)
            }
            i += 1
        }

        return returnKey
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = sortAndGetSections()
        var i = 0
        for (_, names) in sections {
            if i == section {
                return names.count
            }
            i += 1
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sections = sortAndGetSections()
        var i = 0
        var iStruct = 0

        for (_, names) in sections {
            if i == indexPath.section {
                break
            } else {
                iStruct += names.count
            }
            i += 1
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell

        cell.configure(title: filteredArray[iStruct + indexPath.row].name, description: filteredArray[iStruct + indexPath.row].description, image: filteredArray[iStruct + indexPath.row].mainPhoto)

        return cell
    }

    func searchBar(_: UISearchBar,
                   textDidChange searchText: String)
    {
        filteredArray = []
        if searchText == "" {
            filteredArray = DataStorage.shared.groupsArray
        } else {
            for item in DataStorage.shared.groupsArray {
                if item.name.lowercased().contains(searchText.lowercased()) {
                    filteredArray.append(item)
                }
            }
        }
        myTableView.reloadData()
    }
}

extension TableViewGroups: UITableViewDelegate {
    func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let sections = sortAndGetSections()
        var i = 0
        var iStruct = 0

        for (_, names) in sections {
            if i == indexPath.section {
                break
            } else {
                iStruct += names.count
            }
            i += 1
        }
        let contextItem = UIContextualAction(style: .normal, title: "Добавить") { [self] _, _, _ in
            for (index, item) in DataStorage.shared.groupsArray.enumerated() {
                if item.id == filteredArray[iStruct + indexPath.row].id {
                    let user = DataStorage.shared.groupsArray[index]
                    DataStorage.shared.groupsArray.remove(at: index)
                    DataStorage.shared.favoriteGroupsArray.append(user)
                    filteredArray = []
                    if searchBar.text == "" {
                        filteredArray = DataStorage.shared.groupsArray
                    } else {
                        for item in DataStorage.shared.groupsArray {
                            if item.name.lowercased().contains(searchBar.text?.lowercased() ?? "") {
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
