//
//  SearchResultTableViewCell.swift
//  Search List
//
//  Created by Artyom Sadyrin on 2/18/19.
//  Copyright © 2019 Artyom Sadyrin. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var linkLabel: UILabel!

}
