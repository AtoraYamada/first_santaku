//
//  SearchViewController.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/18.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    var searchTags = Array<String>()
    @IBAction func htmlButton(_ sender: CheckBox) {
        if !sender.isChecked == true {
            searchTags.append("HTML")
        }else{
            searchTags.remove(value: "HTML")
        }
        
    }
    
    @IBAction func cssButton(_ sender: CheckBox) {
        if !sender.isChecked == true {
            searchTags.append("CSS")
        }else{
            searchTags.remove(value: "CSS")
        }
        
    }
    @IBAction func rubyButton(_ sender: CheckBox) {
        if !sender.isChecked == true {
            searchTags.append("Ruby")
        }else{
            searchTags.remove(value: "Ruby")
        }
    }
    @IBAction func railsButton(_ sender: CheckBox) {
        if !sender.isChecked == true {
            searchTags.append("Rails")
        }else{
            searchTags.remove(value: "Rails")
        }
    }
    @IBAction func jsButton(_ sender: CheckBox) {
        if !sender.isChecked == true {
            searchTags.append("JavaScript")
        }else{
            searchTags.remove(value: "JavaScript")
        }
    }
    @IBAction func jqueryButton(_ sender: CheckBox) {
        if !sender.isChecked == true {
            searchTags.append("jQuery")
        }else{
            searchTags.remove(value: "jQuery")
        }
    }
    @IBAction func othersButton(_ sender: CheckBox) {
        if !sender.isChecked == true {
            searchTags.append("Others")
        }else{
            searchTags.remove(value: "Others")
        }
    }
}
