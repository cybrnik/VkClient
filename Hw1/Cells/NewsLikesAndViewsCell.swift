//
//  NewsLikesAndViewsCell.swift
//  Hw1
//
//  Created by Nikita on 12.07.2021.
//

import UIKit

class NewsLikesAndViewsCell: UITableViewCell {


    @IBOutlet weak var views: UILabel!
    func clearCell(){

        views.text = nil
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
    func configure( views: String?){
        clearCell()

        if let views = views{
            self.views.text = views
        }
    }
    
}
