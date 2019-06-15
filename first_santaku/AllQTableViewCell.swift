//
//  AllQTableViewCell.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/15.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit

class AllQTableViewCell: UITableViewCell {

    @IBOutlet weak var allTitle: UILabel!
    @IBOutlet weak var allTags: UILabel!
    @IBOutlet weak var allName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
