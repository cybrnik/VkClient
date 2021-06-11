//
//  VkApi.swift
//  Hw1
//
//  Created by Nikita on 03.06.2021.
//

import Foundation
import Alamofire
import RealmSwift
import UIKit

class UserRlm: Object {
    @objc dynamic var name = ""
    dynamic var mainPhoto = UIImage(named: "unnamed")
    @objc dynamic var likes = 0
    @objc dynamic var id = 0
    
}
class GroupRlm: Object {
    @objc dynamic var name = ""
    dynamic var mainPhoto = UIImage(named: "unnamed")
    @objc dynamic var groupDescription = ""
    @objc dynamic var id = 0
    
}

class VkApi {
    
    func saveUserData(_ users: [UserRlm]) {
        
        do {
            
            let realm = try Realm()
            
            
            realm.beginWrite()
            
            
            realm.add(users)
            
            
            try realm.commitWrite()
        } catch {
            
            print(error)
        }
    }
    
    func saveGroupData(_ groups: [GroupRlm]) {
        
        do {
            
            let realm = try Realm()
            
            
            realm.beginWrite()
            
            
            realm.add(groups)
            
            
            try realm.commitWrite()
        } catch {
            
            print(error)
        }
    }
    
    func VKgetFriends(finished: @escaping () -> Void) {
        
        let url = URL(string: "https://api.vk.com/method/friends.get?access_token="+Session.shared.token+"&v=5.103&fields=photo_200_orig&order=hint")
        AF.request(url!,method: .get).responseData { response in
            
            guard let data = response.value
            
            else {return}
            print(data)
            guard let users = try? JSONDecoder().decode(Users.self, from: data)
            else {return}
            var usersRlm = [UserRlm]()
            DataStorage.shared.friendsArray.removeAll()
            for user in users.response.items {
                do {
                    let url = URL(string: user.photo200_Orig)
                    let data = try Data(contentsOf: url!)
                    
                    let userRlm = UserRlm()
                    userRlm.id = user.id
                    userRlm.likes = 0
                    userRlm.mainPhoto = UIImage(data: data)
                    userRlm.name = user.firstName + " " + user.lastName
                    
                    usersRlm.append(userRlm)
                    DataStorage.shared.friendsArray.append(User(name: user.firstName + " " + user.lastName, mainPhoto: UIImage(data: data), photoArray: [UIImage(data: data)!], likes: 0, id: user.id))
                }
                catch{
                    print(error)
                }
            }
            self.saveUserData(usersRlm)
            finished()
            
        }
        
        
    }
    func VKgetGroups(finished: @escaping () -> Void) {
        
        
        let url = URL(string: "https://api.vk.com/method/groups.get?extended=1&access_token="+Session.shared.token+"&v=5.103&fields=photo_200,description,activity")
        
        AF.request(url!,method: .get).responseData { response in
            
            guard let data = response.value
            else {return}
            
            guard let groups = try? JSONDecoder().decode(Groups.self, from: data)
            else {return}
            var groupsRlm = [GroupRlm]()
            DataStorage.shared.favoriteGroupsArray.removeAll()
            for group in groups.response.items {
                do {
                    let url = URL(string: group.photo200)
                    let data = try Data(contentsOf: url!)
                    let groupRlm = GroupRlm()
                    groupRlm.id = group.id
                    groupRlm.groupDescription = group.activity ?? ""
                    groupRlm.mainPhoto = UIImage(data: data)
                    groupRlm.name = group.name
                    groupsRlm.append(groupRlm)
                    DataStorage.shared.favoriteGroupsArray.append(Group(name: group.name, description: group.activity, mainPhoto: UIImage(data: data), id: group.id))
                }
                catch{
                    print(error)
                }
            }
            print(DataStorage.shared.favoriteGroupsArray)
            finished()
            self.saveGroupData(groupsRlm)
        }
        
        
        
        
    }
    func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm" //yyyy
        return formatter.string(from: date)
    }
    func VKgetNews(finished: @escaping () -> Void) {
        
        
        let url = URL(string: "https://api.vk.com/method/newsfeed.get?extended=1&access_token="+Session.shared.token+"&v=5.103&filers=post")
        
        AF.request(url!,method: .get).responseData { response in
            
            guard let data = response.value
            else {return}
            
            guard let news = try? JSONDecoder().decode(NewsModel.self, from: data)
            else {return}
            for new in news.response.items{
                if let _ = new.views?.count{
                    for item in news.response.groups {
                        if item.id * -1 == new.sourceID {
                            do {
                                let url = URL(string: item.photo200)
                                let data = try Data(contentsOf: url!)
                                if ((new.attachments?.isEmpty) != nil) {
                                    if new.attachments!.first?.type == .photo{
                                        do {
                                            let url = URL(string: (new.attachments!.first?.photo?.sizes.last!.url)!)
                                            let dataMain = try Data(contentsOf: url!)
                                            DataStorage.shared.newsArray.append( News(mainImage: UIImage(data: dataMain), text: new.text, avatar: UIImage(data: data)!, views: String(new.views!.count), name: item.name, date: self.stringFromDate(NSDate(timeIntervalSince1970: TimeInterval(new.date)) as Date) )  )
                                            
                                        }
                                        catch{
                                            print(error)
                                        }
                                        break
                                    }
                                    
                                }
                                DataStorage.shared.newsArray.append( News(mainImage: nil, text: new.text, avatar: UIImage(data: data)!, views: String(new.views!.count), name: item.name, date: self.stringFromDate(NSDate(timeIntervalSince1970: TimeInterval(new.date)) as Date) )  )
                                
                            }
                            catch{
                                print(error)
                            }
                            break
                        }
                    }
                    for item in news.response.profiles {
                        if item.id == new.signerID {
                            do {
                                let url = URL(string: item.photo100)
                                let data = try Data(contentsOf: url!)
                                if ((new.attachments?.isEmpty) != nil) {
                                    if new.attachments!.first?.type == .photo{
                                        do {
                                            let url = URL(string: (new.attachments!.first?.photo?.sizes.last!.url)!)
                                            let dataMain = try Data(contentsOf: url!)
                                            DataStorage.shared.newsArray.append( News(mainImage: UIImage(data: dataMain), text: new.text, avatar: UIImage(data: data)!, views: String(new.views!.count), name: item.firstName + " " + item.lastName, date: self.stringFromDate(NSDate(timeIntervalSince1970: TimeInterval(new.date)) as Date) )  )
                                            
                                        }
                                        catch{
                                            print(error)
                                        }
                                        break
                                    }
                                    
                                }
                                DataStorage.shared.newsArray.append( News(mainImage: nil, text: new.text, avatar: UIImage(data: data)!, views: String(new.views!.count), name: item.firstName + " " + item.lastName, date: self.stringFromDate(NSDate(timeIntervalSince1970: TimeInterval(new.date)) as Date) )  )
                                
                            }
                            catch{
                                print(error)
                            }
                            break
                        }
                    }
                    
                    
                    
                    
                }
                
            }
            finished()
            
            
        }
        
        
        
        
    }
    //    func VKgetPhotos() -> String {
    //
    //        let configuration = URLSessionConfiguration.default
    //
    //        let session =  URLSession(configuration: configuration)
    //
    //        let url = URL(string: "https://api.vk.com/method/photos.getAll?access_token="+Session.shared.token+"&v=5.103")
    //
    //
    //        let task = session.dataTask(with: url!) { (data, response, error) in
    //
    //            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
    //
    //            //            return json ?? "ERROR"
    //        }
    //
    //        task.resume()
    //        return "huy"
    //
    //    }
    //    func VKgetGroups(){
    //
    //        let configuration = URLSessionConfiguration.default
    //
    //        let session =  URLSession(configuration: configuration)
    //
    //        let url = URL(string: "https://api.vk.com/method/groups.get?access_token="+Session.shared.token+"&v=5.103")
    //
    //
    //        let task = session.dataTask(with: url!) { (data, response, error) in
    //
    //            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
    //
    //            print(json ?? "ERROR")
    //        }
    //
    //        task.resume()
    //
    //    }
    //    func VKgetGroupsSearch(text: String){
    //
    //        let configuration = URLSessionConfiguration.default
    //
    //        let session =  URLSession(configuration: configuration)
    //
    //        let url = URL(string: "https://api.vk.com/method/groups.search?access_token="+Session.shared.token+"&q="+text+"&v=5.103")
    //
    //
    //        let task = session.dataTask(with: url!) { (data, response, error) in
    //
    //            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
    //
    //            print(json ?? "ERROR")
    //        }
    //
    //        task.resume()
    //
    //    }
    
}
