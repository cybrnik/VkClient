//
//  NewsPhotoCell.swift
//  Hw1
//
//  Created by Nikita on 12.07.2021.
//

import UIKit

class NewsPhotoCell: UITableViewCell {
    @IBOutlet var myImage: UIImageView!

    func clearCell() {
        myImage.image = nil
    }

    override func awakeFromNib() {
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

    func configure(image: UIImage?) {
        clearCell()
        if let image = image {
            myImage.image = image
        }
    }
}
