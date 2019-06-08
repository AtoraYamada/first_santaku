//
//  ViewController.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/08.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        attributed()
        textTitle.adjustsFontSizeToFitWidth = true
    }

    func attributed() {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        let textAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.white,
            .strokeColor : UIColor.green,
            .strokeWidth : -3.0
        ]
        let text = NSAttributedString(string: "SANTAKU", attributes: textAttributes)
        textTitle.attributedText = text
        
    }
}

