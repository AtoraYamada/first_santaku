//
//  CreateFirstViewController.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/13.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit
import Firebase

class CreateFirstViewController: UIViewController, UITextFieldDelegate {
    var db : Firestore!
    @IBOutlet weak var inputTitle: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        inputTitle.delegate = self
    }
    
    @IBAction func getTitle(_ sender: Any) {
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputTitle.resignFirstResponder()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    var tags = Array<String>()
    @IBAction func htmlButton(_ sender: CheckBox) {
        if !sender.isChecked == true {
            tags.append("HTML")
            print(tags)
        }else{
            tags.remove(value: "HTML")
            print(tags)
        }

    }
    
    @IBAction func cssButton(_ sender: CheckBox) {
        if !sender.isChecked == true {
            tags.append("CSS")
            print(tags)
        }else{
            tags.remove(value: "CSS")
            print(tags)
        }
        
    }
    @IBAction func rubyButton(_ sender: CheckBox) {
        if !sender.isChecked == true {
            tags.append("Ruby")
            print(tags)
        }else{
            tags.remove(value: "Ruby")
            print(tags)
        }
    }
    @IBAction func railsButton(_ sender: CheckBox) {
        if !sender.isChecked == true {
            tags.append("Rails")
            print(tags)
        }else{
            tags.remove(value: "Rails")
            print(tags)
        }
    }
    @IBAction func jsButton(_ sender: CheckBox) {
        if !sender.isChecked == true {
            tags.append("JavaScript")
            print(tags)
        }else{
            tags.remove(value: "JavaScript")
            print(tags)
        }
    }
    @IBAction func jqueryButton(_ sender: CheckBox) {
        if !sender.isChecked == true {
            tags.append("jQuery")
            print(tags)
        }else{
            tags.remove(value: "jQuery")
            print(tags)
        }
    }
    @IBAction func othersButton(_ sender: CheckBox) {
        if !sender.isChecked == true {
            tags.append("Others")
            print(tags)
        }else{
            tags.remove(value: "Others")
            print(tags)
        }
    }
}

extension Array where Element: Equatable {
    mutating func remove(value: Element) {
        if let i = self.index(of: value) {
            self.remove(at: i)
        }
    }
}
