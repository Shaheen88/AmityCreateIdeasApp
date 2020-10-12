//
//  HomeTableViewCell.swift
//  AMCIdeas
//
//  Created by Shaheen on 11/10/20.
//

import UIKit
import Firebase

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpDate(idea: Idea) -> Void {
        self.titleLabel.text = idea.title
        self.createdByLabel.text = idea.createdBy
        
        let date =  Date(timeIntervalSince1970: idea.createdAt)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d yyyy, h:mm:ss a"
        let formattedDateInString = formatter.string(from: date)
                
        self.createdAtLabel.text = formattedDateInString
        
        if idea.createdBy == (Auth.auth().currentUser?.email) ?? "" {
            self.iconImageView.image = nil
        } else {
            if idea.favorites.contains((Auth.auth().currentUser?.email) ?? "") {
                self.iconImageView.image = UIImage.init(named: "favorite_cell_Bar_act")
            } else {
                self.iconImageView.image = UIImage.init(named: "favorite_cell_Bar")
            }
        }
    }
    
}
