//
//  ViewController.swift
//  Hw1
//
//  Created by Nikita on 06.04.2021.
//

import UIKit

class ViewController: UIViewController {
    let fromLoginToTabBar = "fromLoginToTabBar"

    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        myButton.layer.cornerRadius = 3

        
        UITextField.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.login.frame.origin.x -= 200
        },
            completion: { _ in
                UITextField.animate(withDuration: 0.3, delay: 0, animations: {
                    self.login.alpha = 0.3
                },completion: {_ in
                    UITextField.animate(withDuration: 0.3, delay: 0, animations: {
                        self.login.alpha = 1
                    })
                })
            })
        UITextField.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.password.frame.origin.x += 200
        },
            completion: {_ in
                UITextField.animate(withDuration: 0.3, delay: 0, animations: {
                    self.password.alpha = 0.3
                },completion: {_ in
                    UITextField.animate(withDuration: 0.3, delay: 0, animations: {
                        self.password.alpha = 1
                    })
                })
            })
       

        
    }
    func fillUsers(){
        DataStorage.shared.favoriteGroupsArray.append(Group(name: "Sandbox", description: "Humor", mainPhoto: UIImage(named: "cat"), id: 3454353))
                                                      
        DataStorage.shared.favoriteGroupsArray.append(Group(name: "MDK", description: "Bored content", mainPhoto: nil, id: 31245))
                                                      
        DataStorage.shared.favoriteGroupsArray.append(Group(name: "Reddit", description: "Memes", mainPhoto: UIImage(named: "man"), id: 12312))
                                                      
        DataStorage.shared.groupsArray.append(Group(name: "SandboxYUMSH", description: "Omagaseble humor", mainPhoto: UIImage(named: "croc"), id: 1000))
        
        
        
        DataStorage.shared.friendsArray.append(User(name: "Alex", mainPhoto: UIImage(named: "skull"), photoArray: [UIImage(named: "croc")!], likes: 0, id: 1000))
        DataStorage.shared.friendsArray.append(User(name: "Kirill",mainPhoto: nil, photoArray: [UIImage(named: "croc")!], likes: 0, id: 1234))
        DataStorage.shared.friendsArray.append(User(name: "Egor", mainPhoto: UIImage(named: "bird"), photoArray: [UIImage(named: "croc")!], likes: 0, id: 20))
        DataStorage.shared.friendsArray.append(User(name: "Oleg", mainPhoto: UIImage(named: "puma"), photoArray: [UIImage(named: "croc")!], likes: 0, id: 3223))
        DataStorage.shared.friendsArray.append(User(name: "Evgeny", mainPhoto: UIImage(named: "catbiker"), photoArray: [UIImage(named: "croc")!], likes: 0, id: 4346))
        
        
        DataStorage.shared.newsArray.append(News(mainImage: UIImage(named: "skull"), text: "", avatar: UIImage(named: "bird")!, views: "10K", name: "Evgeny", date: "Вчера в 10:20"))
        DataStorage.shared.newsArray.append(News(mainImage: UIImage(named: "bird"), text: "И вот я опять", avatar: UIImage(named: "bird")!, views: "100K", name: "Evgeny", date: "Вчера в 10:22"))
        DataStorage.shared.newsArray.append(News(text: "Google Messages получил редизайн в стиле One UI на последних флагманах Samsung\n\nПо сообщению XDA Developers, приложение Google Messages на устройствах Samsung Galaxy S21 претерпевает редизайн, и его внешний вид будет соответствовать другому программному обеспечению One UI от Samsung. Скриншоты, опубликованные XDA и пользователями Reddit, показывают, что главный экран приложения разделен на две части: верхняя информационная область со счетчиком непрочитанных сообщений и нижняя часть со ссылками на каждую беседу.", avatar: UIImage(named: "simp")!, views: "200K", name: "Oleg", date: "Вчера в 10:30"))

        

    }
    func showAlert(text: String){
        let alertCon = UIAlertController(title:"Message" , message: text, preferredStyle: UIAlertController.Style.alert)
        let actionBut = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {_ in self.login.text = ""
            self.password.text = ""
        })
        alertCon.addAction(actionBut)
        present(alertCon, animated: true, completion: nil)
    }
    
    @IBAction func PressBut(_ sender: Any) {
        guard let MLogin = self.login.text else{
            showAlert(text: "ERROR")
            return
        }
        guard let MPass = self.password.text else{
            showAlert(text: "ERROR")
            return
        }
        if(MPass == "123" && MLogin == "Admin"){
            
            fillUsers()
            self.showSpinner()
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {(t) in
                self.removeSpinner()
                self.performSegue(withIdentifier: self.fromLoginToTabBar, sender: self)
            })
            
        }
        else{
            showAlert(text: "Incorrect login or pass")
        }
    }
    

}
fileprivate var aView: UIView?
extension UIViewController {
    
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
