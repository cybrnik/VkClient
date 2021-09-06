//
//  CustomCollectionViewCell.swift
//  Hw1
//
//  Created by Nikita on 16.04.2021.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet var myImage: UIImageView!
    @IBOutlet var like: UIButton!

    @objc func tappedMe() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                           self.myImage.bounds.size.width += self.myImage.bounds.size.width
                       })
    }

    func clearCell() {
        myImage.image = nil
    }

    override func awakeFromNib() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(CustomTableViewCell.tappedMe))
        myImage.addGestureRecognizer(tap)
        myImage.isUserInteractionEnabled = true
        super.awakeFromNib()
        clearCell()
    }

    override func prepareForReuse() {
        clearCell()
    }

    func configure(image: UIImage?) {
        clearCell()
        if let image = image {
            myImage.image = image
        }
    }
}
