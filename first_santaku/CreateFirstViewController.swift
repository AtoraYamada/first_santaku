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
    var userId = ""
    var documentId = ""
    var db : Firestore!
    @IBOutlet weak var inputTitle: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        userId = Auth.auth().currentUser!.uid
        db = Firestore.firestore()
        inputTitle.delegate = self
    }
    @IBAction func getTitle(_ sender: Any) {
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputTitle.resignFirstResponder()
    }
    @IBAction func toSecondButton(_ sender: Any) {
    }
    @IBAction func nextButton(_ sender: Any) {
        guard let title = inputTitle.text else { return }
        guard tags != [] else  { return }
        var ref: DocumentReference? = nil
        ref = db.collection("users").document("\(userId)").collection("userquestions").addDocument(data: [
            "tablename": title,
            "tags": tags,
            ]){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    self.documentId = ref!.documentID
                    print("Document added with ID: \(ref!.documentID)")
                    self.performSegue(withIdentifier: "createdetails", sender: self.documentId)
//                    let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "createquestion") as! CreateQuestionDetailsViewController
//                    storyboard.userId = self.userId
//                    storyboard.documentId = self.documentId
//                    self.present(storyboard, animated: true, completion: nil)
                }
            }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let createQuestionDetailsViewController = segue.destination as? CreateQuestionDetailsViewController{
            createQuestionDetailsViewController.userId = self.userId
            createQuestionDetailsViewController.documentId = self.documentId
        }
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
        }else{
            tags.remove(value: "HTML")
        }

    }
    
    @IBAction func cssButton(_ sender: CheckBox) {
        if !sender.isChecked == true {
            tags.append("CSS")
        }else{
            tags.remove(value: "CSS")
        }
        
    }
    @IBAction func rubyButton(_ sender: CheckBox) {
        if !sender.isChecked == true {
            tags.append("Ruby")
        }else{
            tags.remove(value: "Ruby")
        }
    }
    @IBAction func railsButton(_ sender: CheckBox) {
        if !sender.isChecked == true {
            tags.append("Rails")
        }else{
            tags.remove(value: "Rails")
        }
    }
    @IBAction func jsButton(_ sender: CheckBox) {
        if !sender.isChecked == true {
            tags.append("JavaScript")
        }else{
            tags.remove(value: "JavaScript")
        }
    }
    @IBAction func jqueryButton(_ sender: CheckBox) {
        if !sender.isChecked == true {
            tags.append("jQuery")
        }else{
            tags.remove(value: "jQuery")
        }
    }
    @IBAction func othersButton(_ sender: CheckBox) {
        if !sender.isChecked == true {
            tags.append("Others")
        }else{
            tags.remove(value: "Others")
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
