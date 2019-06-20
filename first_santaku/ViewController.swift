//
//  ViewController.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/08.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var keyboard2 : AVAudioPlayer! = nil
    @IBOutlet weak var textTitle: UILabel!
    
    @IBOutlet weak var enterButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let keyboard2Path = Bundle.main.path(forResource: "keyboard2", ofType: "mp3")!
        let k2:URL = URL(fileURLWithPath: keyboard2Path)
        do {
            keyboard2 = try AVAudioPlayer(contentsOf: k2, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        keyboard2.prepareToPlay()
        attributed()
        buttonatrributed()
    }
    
    @IBAction func enterButton(_ sender: Any) {
        keyboard2.currentTime = 0
        keyboard2.play()
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
        textTitle.adjustsFontSizeToFitWidth = true
        
    }
    
    func buttonatrributed(){
        enterButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        enterButton.setTitle("ENTER", for: .normal)
    }
}

