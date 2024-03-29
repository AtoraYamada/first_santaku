//
//  CreateFirstViewController.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/13.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class CreateFirstViewController: UIViewController, UITextFieldDelegate {
    var keyboard2 : AVAudioPlayer! = nil
    var keyboard1 : AVAudioPlayer! = nil
    var flag: Int!
    var selectedQ: Int!
    var userId = ""
    var documentId = ""
    var tablename = ""
    var detailIds = Array<String>()
    var questions = [Array<String>]()
    var db : Firestore!
    @IBOutlet weak var inputTitle: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        userId = Auth.auth().currentUser!.uid
        db = Firestore.firestore()
        inputTitle.delegate = self
        if flag == 1 {
            inputTitle.text = tablename
            if tags.index(of: "HTML") != nil {
                htmlButton.isChecked = true
            }
            if tags.index(of: "CSS") != nil {
                cssButton.isChecked = true
            }
            if tags.index(of: "Ruby") != nil {
                rubyButton.isChecked = true
            }
            if tags.index(of: "Rails") != nil {
                railsButton.isChecked = true
            }
            if tags.index(of: "JavaScript") != nil {
                jsButton.isChecked = true
            }
            if tags.index(of: "jQuery") != nil {
                jqueryButton.isChecked = true
            }
            if tags.index(of: "Others") != nil {
                othersButton.isChecked = true
            }
            if flag == 1 {
                db.collection("users").document("\(userId)").collection("userquestions").document("\(documentId)").collection("details").order(by: "createdAt").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            self.detailIds.append(document.documentID)
                        }
                    }
                }
                db.collection("users").document("\(self.userId)").collection("userquestions").order(by: "createdAt", descending: true).getDocuments(){(querySnapshot, err) in
                    let a = querySnapshot!.documents[self.selectedQ].documentID
                    self.db.collection("users").document("\(self.userId)").collection("userquestions").document("\(a)").collection("details").order(by: "createdAt").getDocuments(){(querySnapshot, err)in
                        for document in querySnapshot!.documents {
                            self.questions.append(document.data()["detail"]! as! Array<String>)
                        }
                    }
                }
            }
        }
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
    @IBAction func getTitle(_ sender: Any) {
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputTitle.resignFirstResponder()
    }
    @IBAction func toSecondButton(_ sender: Any) {
    }
    @IBAction func nextButton(_ sender: Any) {
        keyboard2.currentTime = 0
        keyboard2.play()
        if flag != 1 {
            let title = inputTitle.text
            var ref: DocumentReference? = nil
            if title != "" && tags != [] {
            ref = db.collection("users").document("\(userId)").collection("userquestions").addDocument(data: [
                "tablename": title!,
                "tags": tags,
                "createdAt": FieldValue.serverTimestamp(),
                ]){ err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        self.documentId = ref!.documentID
                        print("Document added with ID: \(ref!.documentID)")
                        self.performSegue(withIdentifier: "createdetails", sender: self.documentId)
                    }
                }
            } else {
                let alert = UIAlertController(title: "Failed to Create", message: "Fill in both Title and Tags", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                present(alert, animated: true, completion: nil)
            }
        } else {
            let title = inputTitle.text
            if title != "" && tags != [] {
                if questions != [] && detailIds != [] {
                   let ref = db.collection("users").document("\(userId)").collection("userquestions").document("\(documentId)")
                    ref.updateData([
                        "tablename": title!,
                        "tags": tags,
                        "createdAt": FieldValue.serverTimestamp(),
                        ]){ err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("success update")
                                self.performSegue(withIdentifier: "createdetails", sender: self.detailIds)
                            }
                    }
                } else {
                    let alert = UIAlertController(title: "Failed to Update", message: "Wait for seconds, and Tap Next", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Failed to Create", message: "Fill in both Title and Tags", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                present(alert, animated: true, completion: nil)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if flag != 1{
            if let createQuestionDetailsViewController = segue.destination as? CreateQuestionDetailsViewController{
                createQuestionDetailsViewController.userId = self.userId
                createQuestionDetailsViewController.documentId = self.documentId
            }
        } else {
            if let createQuestionDetailsViewController = segue.destination as? CreateQuestionDetailsViewController{
                print(self.detailIds)
                print(self.questions)
                createQuestionDetailsViewController.userId = self.userId
                createQuestionDetailsViewController.documentId = self.documentId
                createQuestionDetailsViewController.detailIds = self.detailIds
                createQuestionDetailsViewController.flag = 1
                createQuestionDetailsViewController.counter = 0
                createQuestionDetailsViewController.questions = self.questions
            }
        }
    }
    
    var tags = Array<String>()
    @IBOutlet weak var htmlButton: CheckBox!
    @IBOutlet weak var cssButton: CheckBox!
    @IBOutlet weak var rubyButton: CheckBox!
    @IBOutlet weak var railsButton: CheckBox!
    @IBOutlet weak var jsButton: CheckBox!
    @IBOutlet weak var jqueryButton: CheckBox!
    @IBOutlet weak var othersButton: CheckBox!
    @IBAction func htmlButton(_ sender: CheckBox) {
        keyboard1.currentTime = 0
        keyboard1.play()
        if tags.index(of: "HTML") != nil{
            sender.isChecked = true
        }
        if !sender.isChecked == true {
            tags.append("HTML")
        }else{
            tags.remove(value: "HTML")
        }

    }
    
    @IBAction func cssButton(_ sender: CheckBox) {
        keyboard1.currentTime = 0
        keyboard1.play()
        if tags.index(of: "CSS") != nil{
            sender.isChecked = true
        }
        if !sender.isChecked == true {
            tags.append("CSS")
        }else{
            tags.remove(value: "CSS")
        }
        
    }
    @IBAction func rubyButton(_ sender: CheckBox) {
        keyboard1.currentTime = 0
        keyboard1.play()
        if tags.index(of: "Ruby") != nil{
            sender.isChecked = true
        }
        if !sender.isChecked == true {
            tags.append("Ruby")
        }else{
            tags.remove(value: "Ruby")
        }
    }
    @IBAction func railsButton(_ sender: CheckBox) {
        keyboard1.currentTime = 0
        keyboard1.play()
        if tags.index(of: "Rails") != nil{
            sender.isChecked = true
        }
        if !sender.isChecked == true {
            tags.append("Rails")
        }else{
            tags.remove(value: "Rails")
        }
    }
    @IBAction func jsButton(_ sender: CheckBox) {
        keyboard1.currentTime = 0
        keyboard1.play()
        if tags.index(of: "JavaScript") != nil{
            sender.isChecked = true
        }
        if !sender.isChecked == true {
            tags.append("JavaScript")
        }else{
            tags.remove(value: "JavaScript")
        }
    }
    @IBAction func jqueryButton(_ sender: CheckBox) {
        keyboard1.currentTime = 0
        keyboard1.play()
        if tags.index(of: "jQuery") != nil{
            sender.isChecked = true
        }
        if !sender.isChecked == true {
            tags.append("jQuery")
        }else{
            tags.remove(value: "jQuery")
        }
    }
    @IBAction func othersButton(_ sender: CheckBox) {
        keyboard1.currentTime = 0
        keyboard1.play()
        if tags.index(of: "Others") != nil{
            sender.isChecked = true
        }
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
