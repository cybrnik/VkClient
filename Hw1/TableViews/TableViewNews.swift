//
//  TableViewNews.swift
//  Hw1
//
//  Created by Nikita on 27.04.2021.
//

import UIKit

class TableViewNews: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        let AnibFile = UINib(nibName: "CustomNewsTableViewCell", bundle: nil)
        myTableView.register(AnibFile, forCellReuseIdentifier: "CustomNewsTableViewCell")
        
        let BnibFile = UINib(nibName: "CustomNewsWithoutImageViewCell", bundle: nil)
        myTableView.register(BnibFile, forCellReuseIdentifier: "CustomNewsWithoutImageViewCell")
        myTableView.reloadData()
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
