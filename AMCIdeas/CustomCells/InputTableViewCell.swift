//
//  InputTableViewCell.swift
//  AMCIdeas
//
//  Created by Shaheen on 11/10/20.
//

import UIKit

class InputTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
