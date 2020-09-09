//
//  EntryCell.swift
//  RecipeApp
//
//  Created by Mishan Wong on 9/8/20.
//  Copyright © 2020 Mishan Wong. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var seasoningsLabel: UILabel!
    
}
