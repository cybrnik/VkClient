//
//  PhotoCollectionView.swift
//  Hw1
//
//  Created by Nikita on 16.04.2021.
//

import UIKit

class PhotoCollectionView: UIViewController {

    @IBOutlet weak var myCollectionView: UICollectionView!
    var photo = UIImage(named: "unnamed")
    var type = String()
    var row = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCollectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
    }
}
extension PhotoCollectionView: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    @objc func clickedButton(sender: UIButton) {

        if type == "Friends"{
            if DataStorage.shared.friendsArray[row].likes == 0 {
                DataStorage.shared.friendsArray[row].likes = 1
                sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
            else if DataStorage.shared.friendsArray[row].likes == 1 {
                DataStorage.shared.friendsArray[row].likes = 0
                sender.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
        if type == "Users"{
            if DataStorage.shared.usersArray[row].likes == 0 {
                DataStorage.shared.usersArray[row].likes = 1
                sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
            else if DataStorage.shared.usersArray[row].likes == 1 {
                DataStorage.shared.usersArray[row].likes = 0
                sender.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
        
        
        UIButton.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, animations: {
            sender.frame.origin.x += 10
        },completion: {_ in UIButton.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, animations: {
            sender.frame.origin.x -= 10
        })})

    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else{return UICollectionViewCell()}
        cell.configure(image: photo)
        if type == "Friends"{
            if DataStorage.shared.friendsArray[row].likes == 0 {
                cell.like.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            if DataStorage.shared.friendsArray[row].likes == 1 {
                cell.like.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }
        if type == "Users"{
            if DataStorage.shared.usersArray[row].likes == 0 {
                cell.like.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            if DataStorage.shared.usersArray[row].likes == 1 {
                cell.like.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }
        cell.like.addTarget(self, action: #selector(clickedButton(sender:)), for: .touchUpInside)
        return cell
    }
    
    
    
    
}
