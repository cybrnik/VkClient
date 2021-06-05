//
//  VkApi.swift
//  Hw1
//
//  Created by Nikita on 03.06.2021.
//

import Foundation
import Alamofire

class VkApi {
    
    func VKgetFriends(finished: @escaping () -> Void) {
        
            let url = URL(string: "https://api.vk.com/method/friends.get?access_token="+Session.shared.token+"&v=5.103&fields=photo_200_orig&order=hint")
            AF.request(url!,method: .get).responseData { response in
                
                guard let data = response.value
                
                else {return}
                print(data)
                guard let users = try? JSONDecoder().decode(Users.self, from: data)
                else {return}
                
                DataStorage.shared.friendsArray.removeAll()
                for user in users.response.items {
                    do {
                        let url = URL(string: user.photo200_Orig)
                        let data = try Data(contentsOf: url!)
                        
                        
                        DataStorage.shared.friendsArray.append(User(name: user.firstName, mainPhoto: UIImage(data: data), photoArray: [UIImage(data: data)!], likes: 0, id: user.id))
                    }
                    catch{
                        print(error)
                    }
                }
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
                
                DataStorage.shared.favoriteGroupsArray.removeAll()
                for group in groups.response.items {
                    do {
                        let url = URL(string: group.photo200)
                        let data = try Data(contentsOf: url!)
                        
                        
                        DataStorage.shared.favoriteGroupsArray.append(Group(name: group.name, description: group.activity, mainPhoto: UIImage(data: data), id: group.id))
                    }
                    catch{
                        print(error)
                    }
                }
                print(DataStorage.shared.favoriteGroupsArray)
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
