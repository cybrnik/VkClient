//
//  TableViewNews.swift
//  Hw1
//
//  Created by Nikita on 27.04.2021.
//

import UIKit

class TableViewNews: UIViewController, UITableViewDelegate {

    @IBOutlet weak var myTableView: UITableView!
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.dataSource = self
        myTableView.delegate = self
        self.showSpinner()
        VkApi().VKgetNews(finished:{
            print(DataStorage.shared.newsArray.count)
            self.myTableView.reloadData()
            self.removeSpinner()
        })
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        myTableView.addSubview(refreshControl) // not required when using UITableViewController
        
        let AnibFile = UINib(nibName: "CustomNewsTableViewCell", bundle: nil)
        myTableView.register(AnibFile, forCellReuseIdentifier: "CustomNewsTableViewCell")
        
        let BnibFile = UINib(nibName: "CustomNewsWithoutImageViewCell", bundle: nil)
        myTableView.register(BnibFile, forCellReuseIdentifier: "CustomNewsWithoutImageViewCell")

        myTableView.reloadData()
    }
    @objc func refresh(_ sender: AnyObject) {
        self.showSpinner()
        VkApi().VKgetNews(finished:{
            print(DataStorage.shared.newsArray.count)
            self.myTableView.reloadData()
            self.removeSpinner()
        })

        refreshControl.endRefreshing()
    }
}
extension TableViewNews: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStorage.shared.newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
                if let _ = DataStorage.shared.newsArray[indexPath.row].mainImage {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CustomNewsTableViewCell", for: indexPath) as! CustomNewsTableViewCell

                    cell.configure(image: DataStorage.shared.newsArray[indexPath.row].mainImage, text: DataStorage.shared.newsArray[indexPath.row].text, name: DataStorage.shared.newsArray[indexPath.row].name, date: DataStorage.shared.newsArray[indexPath.row].date, Avatar: DataStorage.shared.newsArray[indexPath.row].avatar, views: DataStorage.shared.newsArray[indexPath.row].views)

                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CustomNewsWithoutImageViewCell", for: indexPath) as! CustomNewsWithoutImageViewCell
                    cell.configure(text: DataStorage.shared.newsArray[indexPath.row].text, name: DataStorage.shared.newsArray[indexPath.row].name, date: DataStorage.shared.newsArray[indexPath.row].date, Avatar: DataStorage.shared.newsArray[indexPath.row].avatar, views: DataStorage.shared.newsArray[indexPath.row].views)

                    return cell
        
                }
        

        
    }


}
fileprivate var aView: UIView?
extension TableViewNews {
    
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
