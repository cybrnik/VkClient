//
//  NewsAvatarCell.swift
//  Hw1
//
//  Created by Nikita on 12.07.2021.
//

import UIKit

class NewsAvatarCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var Avatar: UIImageView!
    func clearCell() {
        name.text = nil
        date.text = nil
        Avatar.image = nil
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

    func configure(name: String?, date: String?, Avatar: UIImage?) {
        clearCell()
        if let name = name {
            self.name.text = name
        }
        if let date = date {
            self.date.text = date
        }
        if let Avatar = Avatar {
            self.Avatar.image = Avatar
        }
    }
}
