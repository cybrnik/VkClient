//
//  VkApi.swift
//  Hw1
//
//  Created by Nikita on 03.06.2021.
//

import Foundation
import Alamofire
import RealmSwift
import SwiftyJSON
import UIKit

class UserRealmObj: Object {
    @objc dynamic var name = ""
    @objc dynamic var mainPhoto = ""
    @objc dynamic var likes = 0
    @objc dynamic var id = 0

}
class GroupRealmObj: Object {
    @objc dynamic var name = ""
    @objc dynamic var mainPhoto = ""
    @objc dynamic var groupDescription = ""
    @objc dynamic var id = 0

}

class VkApi {

    func saveUserData(_ users: [UserRealmObj]) {

        do {

            let realm = try Realm()


            realm.beginWrite()


            realm.add(users)


            try realm.commitWrite()
        } catch {

            print(error)
        }
    }

    func saveGroupData(_ groups: [GroupRealmObj]) {

        do {

            let realm = try Realm()


            realm.beginWrite()


            realm.add(groups)


            try realm.commitWrite()
        } catch {

            print(error)
        }
    }
    func realmDeleteUsersObjects() {
        do {
            let realm = try Realm()

            let objects = realm.objects(UserRealmObj.self)

            try! realm.write {
                realm.delete(objects)
            }
        } catch let error as NSError {
            // handle error
            print("error - \(error.localizedDescription)")
        }
    }
    func realmDeleteGroupsObjects() {
        do {
            let realm = try Realm()

            let objects = realm.objects(GroupRealmObj.self)

            try! realm.write {
                realm.delete(objects)
            }
        } catch let error as NSError {
            // handle error
            print("error - \(error.localizedDescription)")
        }
    }
    func VKgetFriends(finished: @escaping () -> Void) {

        let url = URL(string: "https://api.vk.com/method/friends.get?access_token=" + Session.shared.token + "&v=5.103&fields=photo_200_orig&order=hint")
        AF.request(url!, method: .get).responseData { response in

            guard let data = response.value

                else { return }
            print(data)
            guard let users = try? JSONDecoder().decode(Users.self, from: data)
                else { return }

            var usersRlm = [UserRealmObj]()
            DataStorage.shared.friendsArray.removeAll()
            self.realmDeleteUsersObjects()
            for user in users.response.items {


                let UserRealmObj = UserRealmObj()
                UserRealmObj.id = user.id
                UserRealmObj.likes = 0
                UserRealmObj.mainPhoto = user.photo200_Orig
                UserRealmObj.name = user.firstName + " " + user.lastName

                usersRlm.append(UserRealmObj)


            }
            self.saveUserData(usersRlm)
            finished()

        }


    }
    func VKgetGroups(finished: @escaping () -> Void) {


        let url = URL(string: "https://api.vk.com/method/groups.get?extended=1&access_token=" + Session.shared.token + "&v=5.103&fields=photo_200,description,activity")

        AF.request(url!, method: .get).responseData { response in

            guard let data = response.value
                else { return }

            guard let groups = try? JSONDecoder().decode(Groups.self, from: data)
                else { return }
            var groupsRlm = [GroupRealmObj]()
            DataStorage.shared.favoriteGroupsArray.removeAll()
            self.realmDeleteGroupsObjects()
            for group in groups.response.items {

                let GroupRealmObj = GroupRealmObj()
                GroupRealmObj.id = group.id
                GroupRealmObj.groupDescription = group.activity ?? ""
                GroupRealmObj.mainPhoto = group.photo200
                GroupRealmObj.name = group.name
                groupsRlm.append(GroupRealmObj)


            }
            self.saveGroupData(groupsRlm)
            finished()

        }




    }
    func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm" //yyyy
        return formatter.string(from: date)
    }
    func VKGetId(finished: @escaping () -> Void) {

        let url = URL(string: "https://api.vk.com/method/users.get?access_token=" + Session.shared.token + "&v=5.103")

        AF.request(url!, method: .get).responseData { response in

            guard let data = response.value
                else { return }

            guard let UserData = try? JSONDecoder().decode(UserData.self, from: data)
                else { return }

            Session.shared.userId = UserData.response[0].id
            finished()

        }


    }
    func VKgetNews(finished: @escaping () -> Void) {


        let url = URL(string: "https://api.vk.com/method/newsfeed.get?extended=1&access_token=" + Session.shared.token + "&v=5.103&filers=post")

        AF.request(url!, method: .get).responseData { response in

            guard let data = response.value
                else { return }
            do {
                let news = try JSON(data: data)
                



                for (_,new):(String,JSON) in news["response"]["items"] {
                    if let _ = new["views"]["count"].number {
                        for (_,item):(String,JSON) in news["response"]["groups"] {
                            

                            if Decimal128(number: item["id"].number!) * -1 == new["source_id"].number {
                                do {
                                    let url = URL(string: item["photo_200"].string ?? "https://vk.com/images/camera_200.png")
                                    let data = try Data(contentsOf: url!)
                                    if ((new["attachments"].array?.isEmpty) != nil) {

                                        if new["attachments"].array?.first!["type"].string == "photo" {
                                            do {
                                                let url = URL(string: (new["attachments"].array?.first!["photo"]["sizes"].array?.last!["url"].string)!)
                                                let dataMain = try Data(contentsOf: url!)
                                                DataStorage.shared.newsArray.append(News(mainImage: UIImage(data: dataMain), text: new["text"].string, avatar: UIImage(data: data)!, views: new["views"]["count"].stringValue, name: item["name"].string!, date: self.stringFromDate(NSDate(timeIntervalSince1970: TimeInterval(new["date"].stringValue)!) as Date)))

                                            }
                                            catch {
                                                print(error)
                                            }
                                            break
                                        }

                                    }
                                    DataStorage.shared.newsArray.append(News(mainImage: nil, text: new["text"].string, avatar: UIImage(data: data)!, views: new["views"]["count"].stringValue, name: item["name"].string!, date:self.stringFromDate(NSDate(timeIntervalSince1970: TimeInterval(new["date"].stringValue  )!) as Date)))

                                }
                                catch {
                                    print(error)
                                }
                                break
                            }
                        }
                        for (_,item):(String,JSON) in news["response"]["profiles"] {
                            if item["id"].number == new["signer_id"].number {
                                do {
                                    let url = URL(string: item["photo_100"].string ?? "https://vk.com/images/camera_200.png")
                                    let data = try Data(contentsOf: url!)
                                    if ((new["attachments"].array?.isEmpty) != nil) {
                                        if new["attachments"].array?.first?["type"] == "photo" {
                                            do {
                                                let url = URL(string: (new["attachments"].array?.first?["photo"]["sizes"].array?.last!["url"].string)!)
                                                let dataMain = try Data(contentsOf: url!)

                                                DataStorage.shared.newsArray.append(News(mainImage: UIImage(data: dataMain), text: new["text"].string, avatar: UIImage(data: data)!, views: new["views"]["count"].stringValue, name: (item["first_name"].string ?? "DELETED") + " " + (item["last_name"].string ?? "DELETED") , date: self.stringFromDate(NSDate(timeIntervalSince1970: TimeInterval(new["date"].stringValue  )!) as Date)))

                                            }
                                            catch {
                                                print(error)
                                            }
                                            break
                                        }

                                    }
                                    DataStorage.shared.newsArray.append(News(mainImage: nil, text: new["text"].string, avatar: UIImage(data: data)!, views: new["views"]["count"].stringValue, name: (item["first_name"].string ?? "DELETED") + " " + (item["last_name"].string ?? "DELETED") , date: self.stringFromDate(NSDate(timeIntervalSince1970: TimeInterval(new["date"].stringValue  )!) as Date)))

                                }
                                catch {
                                    print(error)
                                }
                                break
                            }
                        }


                    }

                }


            }
            catch {
                print(error)
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
