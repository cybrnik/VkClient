//
//  ViewController.swift
//  Hw1
//
//  Created by Nikita on 06.04.2021.
//

import UIKit
import WebKit
class ViewController: UIViewController {
    let fromLoginToTabBar = "fromLoginToTabBar"

    @IBOutlet var WkWebView: WKWebView! {
        didSet {
            WkWebView.navigationDelegate = self
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7033153"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "photos,offline,friends,wall"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.103"),
        ]

        let request = URLRequest(url: urlComponents.url!)

        WkWebView.load(request)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func fillUsers() {
        // VkApi().VKgetFriends()
//        DataStorage.shared.favoriteGroupsArray.append(Group(name: "Sandbox", description: "Humor", mainPhoto: UIImage(named: "cat"), id: 3454353))
//
//        DataStorage.shared.favoriteGroupsArray.append(Group(name: "MDK", description: "Bored content", mainPhoto: nil, id: 31245))
//
//        DataStorage.shared.favoriteGroupsArray.append(Group(name: "Reddit", description: "Memes", mainPhoto: UIImage(named: "man"), id: 12312))
//
//        DataStorage.shared.groupsArray.append(Group(name: "SandboxYUMSH", description: "Omagaseble humor", mainPhoto: UIImage(named: "croc"), id: 1000))
//
//

//        DataStorage.shared.friendsArray.append(User(name: "Alex", mainPhoto: UIImage(named: "skull"), photoArray: [UIImage(named: "croc")!], likes: 0, id: 1000))
//        DataStorage.shared.friendsArray.append(User(name: "Kirill",mainPhoto: nil, photoArray: [UIImage(named: "croc")!], likes: 0, id: 1234))
//        DataStorage.shared.friendsArray.append(User(name: "Egor", mainPhoto: UIImage(named: "bird"), photoArray: [UIImage(named: "croc")!], likes: 0, id: 20))
//        DataStorage.shared.friendsArray.append(User(name: "Oleg", mainPhoto: UIImage(named: "puma"), photoArray: [UIImage(named: "croc")!], likes: 0, id: 3223))
//        DataStorage.shared.friendsArray.append(User(name: "Evgeny", mainPhoto: UIImage(named: "catbiker"), photoArray: [UIImage(named: "croc")!], likes: 0, id: 4346))
//

//        DataStorage.shared.newsArray.append(News(mainImage: UIImage(named: "skull"), text: "", avatar: UIImage(named: "bird")!, views: "10K", name: "Evgeny", date: "Вчера в 10:20"))
//        DataStorage.shared.newsArray.append(News(mainImage: UIImage(named: "bird"), text: "И вот я опять", avatar: UIImage(named: "bird")!, views: "100K", name: "Evgeny", date: "Вчера в 10:22"))
//        DataStorage.shared.newsArray.append(News(text: "Google Messages получил редизайн в стиле One UI на последних флагманах Samsung\n\nПо сообщению XDA Developers, приложение Google Messages на устройствах Samsung Galaxy S21 претерпевает редизайн, и его внешний вид будет соответствовать другому программному обеспечению One UI от Samsung. Скриншоты, опубликованные XDA и пользователями Reddit, показывают, что главный экран приложения разделен на две части: верхняя информационная область со счетчиком непрочитанных сообщений и нижняя часть со ссылками на каждую беседу.", avatar: UIImage(named: "simp")!, views: "200K", name: "Oleg", date: "Вчера в 10:30"))
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }

        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }

        let token = params["access_token"]

        Session.shared.token = token ?? ""

        decisionHandler(.cancel)
        fillUsers()
        performSegue(withIdentifier: fromLoginToTabBar, sender: self)
//        VkService().VKgetFriends()
//        VkService().VKgetPhotos()
//        VkService().VKgetGroups()
//        VkService().VKgetGroupsSearch(text: "MDK")
    }
}
