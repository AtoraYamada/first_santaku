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
import AVFoundation

class PlayViewController: UIViewController {
    var keyboard1 : AVAudioPlayer! = nil
    var timer1 : AVAudioPlayer! = nil
    var timer2 : AVAudioPlayer! = nil
    var correct : AVAudioPlayer! = nil
    var incorrect : AVAudioPlayer! = nil
    var db : Firestore!
    var documentId = ""
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
        self.tabBarController?.tabBar.items?.forEach { $0.isEnabled = false }
        let keyboard1Path = Bundle.main.path(forResource: "keyboard1", ofType: "mp3")!
        let k1:URL = URL(fileURLWithPath: keyboard1Path)
        do {
            keyboard1 = try AVAudioPlayer(contentsOf: k1, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        let timer1Path = Bundle.main.path(forResource: "oven-timer1", ofType: "mp3")!
        let t1:URL = URL(fileURLWithPath: timer1Path)
        do {
            timer1 = try AVAudioPlayer(contentsOf: t1, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        let timer2Path = Bundle.main.path(forResource: "crossing1", ofType: "mp3")!
        let t2:URL = URL(fileURLWithPath: timer2Path)
        do {
            timer2 = try AVAudioPlayer(contentsOf: t2, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        let correctPath = Bundle.main.path(forResource: "correct1", ofType: "mp3")!
        let c1:URL = URL(fileURLWithPath: correctPath)
        do {
            correct = try AVAudioPlayer(contentsOf: c1, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        let incorrectPath = Bundle.main.path(forResource: "incorrect1", ofType: "mp3")!
        let ic1:URL = URL(fileURLWithPath: incorrectPath)
        do {
            incorrect = try AVAudioPlayer(contentsOf: ic1, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        keyboard1.prepareToPlay()
        timer1.prepareToPlay()
        timer2.prepareToPlay()
        correct.prepareToPlay()
        incorrect.prepareToPlay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let timer = タイマー {
            timer.invalidate()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
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
            self.db.collection("userquestions").document("\(documentId)").collection("details").order(by: "createdAt").getDocuments(){(querySnapshot, err)in
                for document in querySnapshot!.documents {
                    self.questions.append(document.data()["detail"]! as! Array<String>)
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
            解答ボタン[i].titleLabel?.adjustsFontSizeToFitWidth = true
        }
        残り時間 = 10
        残り時間ビュー.progress = 1.0
        timer1.currentTime = 0
        timer1.play()
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
        if 残り時間 == 4 {
            timer1.stop()
            timer2.currentTime = 0
            timer2.play()
        }
        if 残り時間 == 0 {
            timer2.stop()
            タイマー!.invalidate()
            self.answers.append(5)
            問題番号 += 1
            出題()
        }
    }
    @IBAction func 解答チェック(_ sender: UIButton) {
        keyboard1.currentTime = 0
        keyboard1.play()
        timer1.stop()
        timer2.stop()
        タイマー!.invalidate()
        let 解答 = sender.currentTitle
        let 問題データ = questions[問題番号]
        let 解答番号 = 問題データ.index(of: 解答!)
        self.answers.append(解答番号!)
        let alert = UIAlertController(title: "\(問題番号+1)問目", message: "", preferredStyle: .alert)
        if 解答番号 == 1 {
            correct.currentTime = 0
            correct.play()
            正解数 += 1
            alert.message = "正解!!"
        } else {
            incorrect.currentTime = 0
            incorrect.play()
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
