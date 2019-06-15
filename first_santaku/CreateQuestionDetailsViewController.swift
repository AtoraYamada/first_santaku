//
//  CreateQuestionDetailsViewController.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/14.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit
import Firebase

class CreateQuestionDetailsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    var db : Firestore!
    var userId = ""
    var documentId = ""
    var detail = Array<String>()
    var detailId = ""

    @IBOutlet weak var inputQuestion: UITextView!
    @IBOutlet weak var inputCorrect: UITextField!
    @IBOutlet weak var inputUncorrect1: UITextField!
    @IBOutlet weak var inputUncorrect2: UITextField!
    @IBOutlet weak var inputAnswer: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        db = Firestore.firestore()
        inputQuestion.delegate = self
        inputCorrect.delegate = self
        inputUncorrect1.delegate = self
        inputUncorrect2.delegate = self
        inputAnswer.delegate = self
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.commitButtonTapped))
        kbToolBar.items = [spacer, commitButton]
        inputQuestion.inputAccessoryView = kbToolBar
        inputAnswer.inputAccessoryView = kbToolBar
    }
    
    @objc func commitButtonTapped() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputQuestion.resignFirstResponder()
        inputCorrect.resignFirstResponder()
        inputUncorrect1.resignFirstResponder()
        inputUncorrect2.resignFirstResponder()
        inputAnswer.resignFirstResponder()
    }
    
    @IBAction func getCorrect(_ sender: Any) {
    }
    @IBAction func getUncorrect1(_ sender: Any) {
    }
    @IBAction func getUncorrect2(_ sender: Any) {
    }
    
    @IBAction func nextButton(_ sender: Any) {
        detail = []
        let question = inputQuestion.text
        let correct = inputCorrect.text
        let uncorrect1 = inputUncorrect1.text
        let uncorrect2 = inputUncorrect2.text
        let answer = inputAnswer.text
        if question != "" && correct != "" && uncorrect1 != "" && uncorrect2 != "" && answer != ""{
            detail += [question!, correct!, uncorrect1!, uncorrect2!, answer!]
            var ref: DocumentReference? = nil
            ref = db.collection("users").document("\(userId)").collection("userquestions").document("\(documentId)").collection("details").addDocument(data: [
                "detail": detail,
                "createdAt": FieldValue.serverTimestamp(),
                ]){ err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        self.detailId = ref!.documentID
                        print("Document added with ID: \(ref!.documentID)")
                    }
            }
        } else {
            let alert = UIAlertController(title: "Failed to Create", message: "Fill in All Entry Point", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let createQuestionDetailsViewController = segue.destination as? CreateQuestionDetailsViewController{
            createQuestionDetailsViewController.userId = self.userId
            createQuestionDetailsViewController.documentId = self.documentId
            createQuestionDetailsViewController.detailId = self.detailId
        }
    }
}
