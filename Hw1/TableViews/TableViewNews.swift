//
//  TableViewNews.swift
//  Hw1
//
//  Created by Nikita on 27.04.2021.
//

import UIKit

class TableViewNews: UIViewController, UITableViewDelegate {
    @IBOutlet var myTableView: UITableView!
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.dataSource = self
        myTableView.delegate = self
        showSpinner()
        VkApi().VKgetNews(finished: {
            print(DataStorage.shared.newsArray.count)
            self.myTableView.reloadData()
            self.removeSpinner()
        })
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        myTableView.addSubview(refreshControl) // not required when using UITableViewController

        //        let AnibFile = UINib(nibName: "CustomNewsTableViewCell", bundle: nil)
        //        myTableView.register(AnibFile, forCellReuseIdentifier: "CustomNewsTableViewCell")
        //
        //        let BnibFile = UINib(nibName: "CustomNewsWithoutImageViewCell", bundle: nil)
        //        myTableView.register(BnibFile, forCellReuseIdentifier: "CustomNewsWithoutImageViewCell")
        //

        let AnibFile = UINib(nibName: "NewsPhotoCell", bundle: nil)
        myTableView.register(AnibFile, forCellReuseIdentifier: "NewsPhotoCell")

        let BnibFile = UINib(nibName: "NewsLikesAndViewsCell", bundle: nil)
        myTableView.register(BnibFile, forCellReuseIdentifier: "NewsLikesAndViewsCell")

        let CnibFile = UINib(nibName: "NewsTextCell", bundle: nil)
        myTableView.register(CnibFile, forCellReuseIdentifier: "NewsTextCell")

        let DnibFile = UINib(nibName: "NewsAvatarCell", bundle: nil)
        myTableView.register(DnibFile, forCellReuseIdentifier: "NewsAvatarCell")

        myTableView.reloadData()
    }

    @objc func refresh(_: AnyObject) {
        showSpinner()
        VkApi().VKgetNews(finished: {
            print(DataStorage.shared.newsArray.count)
            self.myTableView.reloadData()
            self.removeSpinner()
        })

        refreshControl.endRefreshing()
    }
}

extension TableViewNews: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return DataStorage.shared.newsArray.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = DataStorage.shared.newsArray[section].mainImage {
            if let _ = DataStorage.shared.newsArray[section].text {
                return 4
            } else {
                return 3
            }
        } else {
            return 3
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsAvatarCell", for: indexPath) as! NewsAvatarCell
            cell.configure(name: DataStorage.shared.newsArray[indexPath.section].name, date: DataStorage.shared.newsArray[indexPath.section].date, Avatar: DataStorage.shared.newsArray[indexPath.section].avatar)
            return cell
        case 1: // Text

            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell", for: indexPath) as! NewsTextCell
            cell.configure(text: DataStorage.shared.newsArray[indexPath.section].text)
            return cell

        case 2: // Photo or Likes
            if let _ = DataStorage.shared.newsArray[indexPath.section].mainImage {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPhotoCell", for: indexPath) as! NewsPhotoCell
                cell.configure(image: DataStorage.shared.newsArray[indexPath.section].mainImage)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsLikesAndViewsCell", for: indexPath) as! NewsLikesAndViewsCell
                cell.configure(views: DataStorage.shared.newsArray[indexPath.section].views)
                return cell
            }

        case 3: // Likes
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsLikesAndViewsCell", for: indexPath) as! NewsLikesAndViewsCell
            cell.configure(views: DataStorage.shared.newsArray[indexPath.section].views)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsLikesAndViewsCell", for: indexPath) as! NewsLikesAndViewsCell
            cell.configure(views: DataStorage.shared.newsArray[indexPath.section].views)
            return cell
        }
    }
}

private var aView: UIView?
extension TableViewNews {
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
