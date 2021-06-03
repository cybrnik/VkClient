//
//  CustomTableViewCell.swift
//  Hw1
//
//  Created by Nikita on 14.04.2021.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var MyImageView: UIImageView!
    @IBOutlet weak var MyTitle: UILabel!
    @IBOutlet weak var MyDescription: UILabel!
    
    func clearCell(){
        MyTitle.text = nil
        MyDescription.text = nil
        MyImageView.image = nil
    }
    @objc func tappedMe(){
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        self.MyImageView.bounds.size.width += self.MyImageView.bounds.size.width
        })
    }
    override func awakeFromNib() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(CustomTableViewCell.tappedMe))
        MyImageView.addGestureRecognizer(tap)
        MyImageView.isUserInteractionEnabled = true
        MyImageView.layer.cornerRadius = 20
        clearCell()
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configure(title: String?, description: String?, image: UIImage?){
        clearCell()
        if let title = title{
            MyTitle.text = title
        }
        if let description = description{
            MyDescription.text = description
        }
        if let image = image{
            MyImageView.image = image
        }else{
            MyImageView.image = UIImage(named: "unnamed")
        }
    }
}
