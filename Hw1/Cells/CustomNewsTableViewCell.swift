//
//  CustomNewsTableViewCell.swift
//  Hw1
//
//  Created by Nikita on 27.04.2021.
//

import UIKit

class CustomNewsTableViewCell: UITableViewCell {
    @IBOutlet var mainText: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var Avatar: UIImageView!
    @IBOutlet var myImage: UIImageView!
    @IBOutlet var views: UILabel!
    func clearCell() {
        myImage.image = nil
        mainText.text = nil
        name.text = nil
        date.text = nil
        Avatar.image = nil
        views.text = nil
    }

    override func awakeFromNib() {
        Avatar.layer.cornerRadius = 20
        // myImage.layer.cornerRadius = 0
        super.awakeFromNib()
        clearCell()
    }

    override func prepareForReuse() {
        clearCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(image: UIImage?, text: String?, name: String?, date: String?, Avatar: UIImage?, views: String?) {
        clearCell()
        if let image = image {
            myImage.image = image
        }
        if let text = text {
            mainText.text = text
        }
        if let name = name {
            self.name.text = name
        }
        if let date = date {
            self.date.text = date
        }
        if let Avatar = Avatar {
            self.Avatar.image = Avatar
        }
        if let views = views {
            self.views.text = views
        }
    }
}
