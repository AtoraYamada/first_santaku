//
//  AnswerTableViewCell.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/13.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var 問題文: UILabel!
    @IBOutlet weak var userAnswer: UILabel!
    @IBOutlet weak var correctAnswer: UILabel!
    @IBOutlet weak var 解説: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
