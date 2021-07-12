//
//  NewsTextCell.swift
//  Hw1
//
//  Created by Nikita on 12.07.2021.
//

import UIKit

class NewsTextCell: UITableViewCell {

    @IBOutlet weak var mainText: UILabel!

    func clearCell(){

        mainText.text = nil

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
    func configure(text: String?){
        clearCell()

        if let text = text{
            mainText.text = text
        }

    }
    
}
