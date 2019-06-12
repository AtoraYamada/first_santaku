//
//  PlayViewController.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/12.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit
import Firebase

class PlayViewController: UIViewController {
    var db : Firestore!
    var selectedQ: Int!
    var questions = [Array<Any>]()
    @IBOutlet weak var 問題ラベル: UILabel!
    @IBOutlet weak var 残り時間ビュー: UIProgressView!
    @IBOutlet var 解答ボタン: [UIButton]!
    
    let 問題リスト = [
        ["Rubyでくクラス変数の定義方法は？", "@@hoge", "@hoge", "var hoge"],
        ["TECH::EXPERTでは何を一番重要視している？", "アウトプット", "インプット", "昼食"],
        ["Rubyで曜日を数値で取得できるメソッドは？", ".wday()", ".day()", ".week()"],
        ]
    var 問題番号 = 0
    var 残り時間 = 10
    var 正解数 = 0
    var タイマー : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        readQ()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(questions)
        出題()
    }
    func readQ(){
        db.collection("questions").getDocuments(){(querySnapshot, err) in
            let a = querySnapshot!.documents[self.selectedQ].documentID
            self.db.collection("questions").document("\(a)").collection("details").getDocuments(){(querySnapshot, err)in
                    for document in querySnapshot!.documents {
                        self.questions.append(document.data()["detail"]! as! Array)
                }
            }
        }
        
    }
    func 出題() {
        if 問題番号 >= 問題リスト.count {
            let alert = UIAlertController(title: "終了", message: "\(正解数)問正解!", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        let 問題データ = 問題リスト[問題番号]
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
        let 問題データ = 問題リスト[問題番号]
        let 解答番号 = 問題データ.index(of: 解答!)
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
