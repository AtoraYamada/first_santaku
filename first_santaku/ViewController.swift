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
    var audioPlayerInstance : AVAudioPlayer! = nil
    @IBOutlet weak var textTitle: UILabel!
    
    @IBOutlet weak var enterButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let soundFilePath = Bundle.main.path(forResource: "keyboard2", ofType: "mp3")!
        let sound:URL = URL(fileURLWithPath: soundFilePath)
        do {
            audioPlayerInstance = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        audioPlayerInstance.prepareToPlay()
        attributed()
        buttonatrributed()
    }
    
    @IBAction func enterButton(_ sender: Any) {
        audioPlayerInstance.currentTime = 0
        audioPlayerInstance.play()
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

