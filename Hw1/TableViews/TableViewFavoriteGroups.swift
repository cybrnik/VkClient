//
//  TableViewFavoriteGroups.swift
//  Hw1
//
//  Created by Nikita on 15.04.2021.
//

import RealmSwift
import UIKit
class TableViewFavoriteGroups: UIViewController, UISearchBarDelegate {
    var token: NotificationToken?
    var filteredArray = DataStorage.shared.favoriteGroupsArray
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var myTableView: UITableView!
    var refreshControl = UIRefreshControl()
    var photoService: PhotoService?
    override func viewWillAppear(_ animated: Bool) {
        filteredArray = []
        if searchBar.text == "" {
            filteredArray = DataStorage.shared.favoriteGroupsArray
        } else {
            for item in DataStorage.shared.favoriteGroupsArray {
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
            filteredArray = DataStorage.shared.favoriteGroupsArray
        } else {
            for item in DataStorage.shared.favoriteGroupsArray {
                if item.name.lowercased().contains(searchBar.text?.lowercased() ?? "") {
                    filteredArray.append(item)
                }
            }
        }
        super.viewDidLoad()
        searchBar.delegate = self
        myTableView.dataSource = self
        myTableView.delegate = self
        showSpinner()
        let realm = try! Realm()
        let groupsRlm = realm.objects(GroupRealmObj.self)
        token = groupsRlm.observe { (changes: RealmCollectionChange) in
            switch changes {
            case let .initial(results):
                print(results)
            case let .update(results, _, _, _):
                // print(results, deletions, insertions, modifications)
                DataStorage.shared.favoriteGroupsArray.removeAll()
                for group in results {
//                    do {
                    ////                        let url = URL(string: group.mainPhoto)
//                        let data = try Data(contentsOf: url!)
                    DataStorage.shared.favoriteGroupsArray.append(Group(name: group.name, description: group.groupDescription, mainPhoto: self.photoService?.photo(byUrl: group.mainPhoto), id: group.id))
//                    }
//                    catch{
//                        print(error)
//                    }
                }
                self.myTableView.reloadData()

            case let .error(error):
                print(error)
            }
        }

        VkApi().VKgetGroups(finished: {
            do {
                let realm = try Realm()
                let groups = realm.objects(GroupRealmObj.self)
                for group in groups {
//                    do {
                    //                        let url = URL(string: group.mainPhoto)
                    //                        let data = try Data(contentsOf: url!)
                    DataStorage.shared.favoriteGroupsArray.append(Group(name: group.name, description: group.groupDescription, mainPhoto: self.photoService?.photo(byUrl: group.mainPhoto), id: group.id))
//                    }
//                    catch{
//                        print(error)
//                    }
                }
            } catch {
                print(error)
            }
            self.filteredArray = []
            if self.searchBar.text == "" {
                self.filteredArray = DataStorage.shared.favoriteGroupsArray
            } else {
                for item in DataStorage.shared.favoriteGroupsArray {
                    if item.name.lowercased().contains(self.searchBar.text?.lowercased() ?? "") {
                        self.filteredArray.append(item)
                    }
                }
            }

            self.myTableView.reloadData()
            self.removeSpinner()
        })
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        myTableView.addSubview(refreshControl) // not required when using UITableViewController

        let nibFile = UINib(nibName: "CustomTableViewCell", bundle: nil)

        myTableView.register(nibFile, forCellReuseIdentifier: "CustomTableViewCell")
        myTableView.reloadData()
    }

    @objc func refresh(_: AnyObject) {
        showSpinner()
        VkApi().VKgetGroups(finished: {
            do {
                let realm = try Realm()
                let groups = realm.objects(GroupRealmObj.self)
                for group in groups {
                    //                    do {
                    //                        let url = URL(string: group.mainPhoto)
                    //                        let data = try Data(contentsOf: url!)
                    DataStorage.shared.favoriteGroupsArray.append(Group(name: group.name, description: group.groupDescription, mainPhoto: self.photoService?.photo(byUrl: group.mainPhoto), id: group.id))
                    //                    }
                    //                    catch{
                    //                        print(error)
                    //                    }
                }
            } catch {
                print(error)
            }
            self.filteredArray = []
            if self.searchBar.text == "" {
                self.filteredArray = DataStorage.shared.favoriteGroupsArray
            } else {
                for item in DataStorage.shared.favoriteGroupsArray {
                    if item.name.lowercased().contains(self.searchBar.text?.lowercased() ?? "") {
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
            filteredArray = DataStorage.shared.favoriteGroupsArray
        } else {
            for item in DataStorage.shared.favoriteGroupsArray {
                if item.name.lowercased().contains(searchText.lowercased()) {
                    filteredArray.append(item)
                }
            }
        }
        myTableView.reloadData()
    }
}

extension TableViewFavoriteGroups: UITableViewDelegate {
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
        let contextItem = UIContextualAction(style: .destructive, title: "Удалить") { [self] _, _, _ in
            for (index, item) in DataStorage.shared.favoriteGroupsArray.enumerated() {
                if item.id == filteredArray[iStruct + indexPath.row].id {
                    let user = DataStorage.shared.favoriteGroupsArray[index]
                    DataStorage.shared.favoriteGroupsArray.remove(at: index)
                    DataStorage.shared.groupsArray.append(user)
                    filteredArray = []
                    if searchBar.text == "" {
                        filteredArray = DataStorage.shared.favoriteGroupsArray
                    } else {
                        for item in DataStorage.shared.favoriteGroupsArray {
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
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
}

private var aView: UIView?
extension TableViewFavoriteGroups {
    func showSpinner() {
        aView = UIView(frame: view.bounds)
        aView?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = aView!.center
        ai.startAnimating()

        aView?.addSubview(ai)
        view.addSubview(aView!)
    }

    func removeSpinner() {
        aView!.removeFromSuperview()
        aView = nil
    }
}
