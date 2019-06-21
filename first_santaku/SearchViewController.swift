//
//  SearchViewController.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/18.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit
import AVFoundation

class SearchViewController: UIViewController {
    var keyboard2 : AVAudioPlayer! = nil
    var keyboard1 : AVAudioPlayer! = nil
    var searchSet = Set<String>()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let keyboard2Path = Bundle.main.path(forResource: "keyboard2", ofType: "mp3")!
        let k2:URL = URL(fileURLWithPath: keyboard2Path)
        do {
            keyboard2 = try AVAudioPlayer(contentsOf: k2, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        let keyboard1Path = Bundle.main.path(forResource: "keyboard1", ofType: "mp3")!
        let k1:URL = URL(fileURLWithPath: keyboard1Path)
        do {
            keyboard1 = try AVAudioPlayer(contentsOf: k1, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        keyboard1.prepareToPlay()
        keyboard2.prepareToPlay()
    }
    
    @IBAction func searchButton(_ sender: Any) {
        keyboard2.currentTime = 0
        keyboard2.play()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        searchSet = Set(searchTags)
    }
    
    var searchTags = Array<String>()
    @IBAction func htmlButton(_ sender: CheckBox) {
        keyboard1.currentTime = 0
        keyboard1.play()
        if !sender.isChecked == true {
            searchTags.append("HTML")
        }else{
            searchTags.remove(value: "HTML")
        }
        
    }
    
    @IBAction func cssButton(_ sender: CheckBox) {
        keyboard1.currentTime = 0
        keyboard1.play()
        if !sender.isChecked == true {
            searchTags.append("CSS")
        }else{
            searchTags.remove(value: "CSS")
        }
        
    }
    @IBAction func rubyButton(_ sender: CheckBox) {
        keyboard1.currentTime = 0
        keyboard1.play()
        if !sender.isChecked == true {
            searchTags.append("Ruby")
        }else{
            searchTags.remove(value: "Ruby")
        }
    }
    @IBAction func railsButton(_ sender: CheckBox) {
        keyboard1.currentTime = 0
        keyboard1.play()
        if !sender.isChecked == true {
            searchTags.append("Rails")
        }else{
            searchTags.remove(value: "Rails")
        }
    }
    @IBAction func jsButton(_ sender: CheckBox) {
        keyboard1.currentTime = 0
        keyboard1.play()
        if !sender.isChecked == true {
            searchTags.append("JavaScript")
        }else{
            searchTags.remove(value: "JavaScript")
        }
    }
    @IBAction func jqueryButton(_ sender: CheckBox) {
        keyboard1.currentTime = 0
        keyboard1.play()
        if !sender.isChecked == true {
            searchTags.append("jQuery")
        }else{
            searchTags.remove(value: "jQuery")
        }
    }
    @IBAction func othersButton(_ sender: CheckBox) {
        keyboard1.currentTime = 0
        keyboard1.play()
        if !sender.isChecked == true {
            searchTags.append("Others")
        }else{
            searchTags.remove(value: "Others")
        }
    }
}
