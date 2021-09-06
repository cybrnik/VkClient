//
//  TableViewFriends.swift
//  Hw1
//
//  Created by Nikita on 15.04.2021.
//

import Alamofire
import Firebase
import RealmSwift
import UIKit
class TableViewFriends: UIViewController, UISearchBarDelegate {
    var token: NotificationToken?
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var myTableView: UITableView!
    var photo = UIImage(named: "unnamed")!
    var row = Int()
    var type = "Friends"
    var filteredArray = DataStorage.shared.friendsArray
    var refreshControl = UIRefreshControl()
    var ref: DatabaseReference!

    override func viewWillAppear(_ animated: Bool) {
        filteredArray = []
        if searchBar.text == "" {
            filteredArray = DataStorage.shared.friendsArray
        } else {
            for item in DataStorage.shared.friendsArray {
                if item.name.lowercased().contains(searchBar.text?.lowercased() ?? "") {
                    filteredArray.append(item)
                }
            }
        }

        super.viewWillAppear(animated)
        myTableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "fromFriendsToPhoto" {
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
            lhs.name < rhs.name
        }

        var friends = [String]()
        for item in filteredArray {
            friends.append(item.name)
        }
        let sections = Dictionary(grouping: friends) { country -> Character in
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

    //    @objc func refresh() {
    //
    //       self.myTableView.reloadData() // a refresh the tableView.
    //
    //   }
    //
    override func viewDidLoad() {
        ref = Database.database().reference()

        filteredArray = []
        if searchBar.text == "" {
            filteredArray = DataStorage.shared.friendsArray
        } else {
            for item in DataStorage.shared.friendsArray {
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
        let usersRlm = realm.objects(UserRealmObj.self)
        token = usersRlm.observe { (changes: RealmCollectionChange) in
            switch changes {
            case let .initial(results):
                print(results)
            case let .update(results, _, _, _):
                // print(results, deletions, insertions, modifications)
                DataStorage.shared.friendsArray.removeAll()
                for user in results {
                    do {
                        let url = URL(string: user.mainPhoto)
                        let data = try Data(contentsOf: url!)
                        DataStorage.shared.friendsArray.append(User(name: user.name, mainPhoto: UIImage(data: data), photoArray: [UIImage(data: data)!], likes: 0, id: user.id))
                    } catch {
                        print(error)
                    }
                }
                self.myTableView.reloadData()

            case let .error(error):
                print(error)
            }
        }

        VkApi().VKgetFriends(finished: {
            do {
                let realm = try Realm()
                let users = realm.objects(UserRealmObj.self)
                for user in users {
                    do {
                        let url = URL(string: user.mainPhoto)
                        let data = try Data(contentsOf: url!)
                        DataStorage.shared.friendsArray.append(User(name: user.name, mainPhoto: UIImage(data: data), photoArray: [UIImage(data: data)!], likes: 0, id: user.id))
                    } catch {
                        print(error)
                    }
                }
            } catch {
                print(error)
            }

            self.filteredArray = []
            if self.searchBar.text == "" {
                self.filteredArray = DataStorage.shared.friendsArray
            } else {
                for item in DataStorage.shared.friendsArray {
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
        let url = URL(string: "https://api.vk.com/method/groups.get?extended=1&access_token=" + Session.shared.token + "&v=5.103&fields=photo_200,description,activity")

        AF.request(url!, method: .get).responseData { response in

            guard let data = response.value
            else { return }
            guard let newStr = String(data: data, encoding: .utf8)
            else { return }
            VkApi().VKGetId(finished: {
                self.ref.child(String(Session.shared.userId)).setValue(newStr)

            })
        }
    }

    @objc func refresh(_: AnyObject) {
        showSpinner()
        VkApi().VKgetFriends(finished: {
            do {
                let realm = try Realm()
                let users = realm.objects(UserRealmObj.self)
                for user in users {
                    do {
                        let url = URL(string: user.mainPhoto)
                        let data = try Data(contentsOf: url!)
                        DataStorage.shared.friendsArray.append(User(name: user.name, mainPhoto: UIImage(data: data), photoArray: [UIImage(data: data)!], likes: 0, id: user.id))
                    } catch {
                        print(error)
                    }
                }
            } catch {
                print(error)
            }

            self.filteredArray = []
            if self.searchBar.text == "" {
                self.filteredArray = DataStorage.shared.friendsArray
            } else {
                for item in DataStorage.shared.friendsArray {
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

extension TableViewFriends: UITableViewDataSource {
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

        cell.configure(title: filteredArray[iStruct + indexPath.row].name, description: filteredArray[iStruct + indexPath.row].status, image: filteredArray[iStruct + indexPath.row].mainPhoto)

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
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

        photo = filteredArray[iStruct + indexPath.row].mainPhoto ?? UIImage(named: "unnamed")!
        row = iStruct + indexPath.row
        for (index, item) in DataStorage.shared.friendsArray.enumerated() {
            if item.id == filteredArray[iStruct + indexPath.row].id {
                row = index
            }
        }
        performSegue(withIdentifier: "fromFriendsToPhoto", sender: nil)
    }

    func searchBar(_: UISearchBar,
                   textDidChange searchText: String)
    {
        filteredArray = []
        if searchText == "" {
            filteredArray = DataStorage.shared.friendsArray
        } else {
            for item in DataStorage.shared.friendsArray {
                if item.name.lowercased().contains(searchText.lowercased()) {
                    filteredArray.append(item)
                }
            }
        }
        myTableView.reloadData()
    }
}

extension TableViewFriends: UITableViewDelegate {
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
            for (index, item) in DataStorage.shared.friendsArray.enumerated() {
                if item.id == filteredArray[iStruct + indexPath.row].id {
                    let user = DataStorage.shared.friendsArray[index]
                    DataStorage.shared.friendsArray.remove(at: index)
                    DataStorage.shared.usersArray.append(user)
                    filteredArray = []
                    if searchBar.text == "" {
                        filteredArray = DataStorage.shared.friendsArray
                    } else {
                        for item in DataStorage.shared.friendsArray {
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
extension TableViewFriends {
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
