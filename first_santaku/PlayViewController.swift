//
//  PlayViewController.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/12.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class PlayViewController: UIViewController {
    var db : Firestore!
    var flag: Int!
    var selectedQ: Int!
    var questions = [Array<String>]()
    var answers = Array<Int>()
    let user = Auth.auth().currentUser
    @IBOutlet weak var 問題ラベル: UILabel!
    @IBOutlet weak var 残り時間ビュー: UIProgressView!
    @IBOutlet var 解答ボタン: [UIButton]!
    
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    
    @IBOutlet weak var loadingBack: UIImageView!
    var 問題番号 = 0
    var 残り時間 = 10
    var 正解数 = 0
    var タイマー : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.startAnimating()
        loadingView.backgroundColor = UIColor.clear
        db = Firestore.firestore()
        残り時間ビュー.transform = CGAffineTransform(scaleX: 1.0, y: 3.0)
        let queue = DispatchQueue(label: "read")
        queue.sync{
            self.readQ()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.出題()
            self.loadingView.stopAnimating()
            self.loadingBack.isHidden = true
        }
        
    }
    func readQ(){
        if flag == 1{
            db.collection("questions").getDocuments(){(querySnapshot, err) in
                let a = querySnapshot!.documents[self.selectedQ].documentID
                self.db.collection("questions").document("\(a)").collection("details").getDocuments(){(querySnapshot, err)in
                        for document in querySnapshot!.documents {
                            self.questions.append(document.data()["detail"]! as! Array<String>)
                    }
                }
            }
        }else if flag == 2{
            db.collection("users").document("\(self.user!.uid)").collection("userquestions").order(by: "createdAt", descending: true).getDocuments(){(querySnapshot, err) in
                let a = querySnapshot!.documents[self.selectedQ].documentID
                self.db.collection("users").document("\(self.user!.uid)").collection("userquestions").document("\(a)").collection("details").order(by: "createdAt").getDocuments(){(querySnapshot, err)in
                    for document in querySnapshot!.documents {
                        self.questions.append(document.data()["detail"]! as! Array<String>)
                    }
                }
            }
        }else if flag == 3{
            db.collection("userquestions").order(by: "createdAt", descending: true).getDocuments(){(querySnapshot, err) in
                let a = querySnapshot!.documents[self.selectedQ].documentID
                self.db.collection("userquestions").document("\(a)").collection("details").order(by: "createdAt").getDocuments(){(querySnapshot, err)in
                    for document in querySnapshot!.documents {
                        self.questions.append(document.data()["detail"]! as! Array<String>)
                    }
                }
            }
        }
    }
    func 出題() {
        if 問題番号 >= questions.count {
            let alert = UIAlertController(title: "終了", message: "\(正解数)問正解!", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (_) in
                let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "answer") as! AnswerTableViewController
                storyboard.questions = self.questions
                storyboard.answers = self.answers
                self.present(storyboard, animated: true, completion: nil)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        let 問題データ = questions[問題番号]
        問題ラベル.text = 問題データ[0]
        let 番号 = 番号リスト()
        for i in 0...2 {
            解答ボタン[i].setTitle(問題データ[番号[i]], for: UIControl.State())
        }
        残り時間 = 10
        残り時間ビュー.progress = 1.0
        タイマー = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(タイマー関数), userInfo: nil, repeats: true)
    }
    
    func 番号リスト() -> [Int] {
        var リスト = [1,2,3]
        for _ in 1...10 {
            let i1 = Int(arc4random() % 3)
            let i2 = Int(arc4random() % 3)
            if i1 != i2 {
                リスト.swapAt(i1, i2)
            }
        }
        return リスト
    }
    
    @objc func タイマー関数() {
        残り時間 -= 1
        残り時間ビュー.progress = Float(残り時間) / 10
        if 残り時間 == 0 {
            タイマー!.invalidate()
            問題番号 += 1
            出題()
        }
    }
    @IBAction func 解答チェック(_ sender: UIButton) {
        タイマー!.invalidate()
        let 解答 = sender.currentTitle
        let 問題データ = questions[問題番号]
        let 解答番号 = 問題データ.index(of: 解答!)
        self.answers.append(解答番号!)
        let alert = UIAlertController(title: "\(問題番号+1)問目", message: "", preferredStyle: .alert)
        if 解答番号 == 1 {
            正解数 += 1
            alert.message = "正解!!"
        } else {
            alert.message = "はずれ!!"
        }
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            self.問題番号 += 1
            self.出題()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
