//
//  AllQTableViewController.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/15.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class AllQTableViewController: UITableViewController {
    var keyboard2 : AVAudioPlayer! = nil
    var keyboard1 : AVAudioPlayer! = nil
    var documentId = ""
    var searchSet = Set<String>()
    let semaphore = DispatchSemaphore(value: 1)
    var questionList:[String] = []
    var tagList = [Array<String>]()
    var idList:[String] = []
    var userList:[DocumentReference] = []
    var db : Firestore!
    fileprivate let refreshCtl = UIRefreshControl()
    @IBOutlet var allQTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        allQTableView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(AllQTableViewController.refresh(sender:)), for: .valueChanged)
        let image = UIImage(named: "matrix-356024_640")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height))
        imageView.image = image
        self.tableView.backgroundView = imageView
        tableView.register(UINib(nibName: "AllQTableViewCell", bundle: nil),forCellReuseIdentifier:"allCell")
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableView.automaticDimension
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
        db = Firestore.firestore()
        readData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.items?.forEach { $0.isEnabled = true }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allCell", for: indexPath) as! AllQTableViewCell
        var newTags:[String] = []
        if questionList != [] {
            let selectedquestion = self.questionList[indexPath.row]
            cell.allTitle.text = selectedquestion
            let selectedtags = self.tagList[indexPath.row]
            for tag in selectedtags{
                newTags.append("#\(tag)")
            }
            let selecteduserref = self.userList[indexPath.row]
            db.document("\(selecteduserref.path)").getDocument() { (document, err) in
                let selectedusername = document!.data()!["username"]
                cell.allName.text = selectedusername as? String
            }
            cell.allTags.text = newTags.joined(separator: " ")
            cell.allTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.allTitle.font = UIFont(name: "Kefa", size: 22)
            cell.allTitle.adjustsFontSizeToFitWidth = true
            cell.allTags.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.allTags.font = UIFont(name: "Kefa", size: 15)
            cell.allTags.sizeToFit()
            cell.allName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.allName.font = UIFont(name: "Kefa", size: 15)
            cell.allName.adjustsFontSizeToFitWidth = true
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
        } else {
            self.idList.append("1")
            cell.allTitle.text = "再読み込みしてください"
            cell.allTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.allTitle.font = UIFont(name: "Kefa", size: 22)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        keyboard2.currentTime = 0
        keyboard2.play()
        self.documentId = idList[indexPath.row]
        let selectedquestion = indexPath.row
        self.performSegue(withIdentifier: "moveToAllQ", sender: selectedquestion)
    }
    @IBAction func searchButton(_ sender: Any) {
        keyboard1.currentTime = 0
        keyboard1.play()
        self.performSegue(withIdentifier: "search", sender: self)
    }
    func setupMethod(){}
    @IBAction func returnToMe(segue: UIStoryboardSegue) {
        if segue.source is SearchViewController {
            if let searchViewController = segue.source as? SearchViewController{
                searchSet = searchViewController.searchSet
                searchData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let playViewController = segue.destination as? PlayViewController{
            if let selectedquestion = sender as? Int{
                playViewController.selectedQ = selectedquestion
                playViewController.flag = 3
                playViewController.documentId = self.documentId
            }
        }
    }
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
        searchData()
    }
    @IBAction func backToAll(_ sender: Any) {
        searchSet = []
        readData()
        keyboard1.currentTime = 0
        keyboard1.play()
    }
    
}
extension AllQTableViewController{
    func readData(){
        DispatchQueue.global().async {
            self.idList = []
            self.questionList = []
            self.tagList = []
            self.userList = []
            self.db.collection("userquestions").order(by: "createdAt", descending: true).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.idList.append(document.documentID)
                        self.questionList.append(document.data()["tablename"] as! String)
                        self.tagList.append(document.data()["tags"] as! Array<String>)
                        self.userList.append(document.data()["userRef"] as! DocumentReference)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.semaphore.signal()
                }
            }
        }
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        if searchSet == [] {
            readData()
            semaphore.wait()
            semaphore.signal()
            refreshCtl.endRefreshing()
        } else {
            searchData()
            semaphore.wait()
            semaphore.signal()
            refreshCtl.endRefreshing()
        }
    }
    
    func searchData(){
        DispatchQueue.global().async {
            self.idList = []
            self.questionList = []
            self.tagList = []
            self.userList = []
            self.db.collection("userquestions").order(by: "createdAt", descending: true).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let tag = document.data()["tags"] as! Array<String>
                        if self.searchSet.isSubset(of: Set(tag)) {
                            self.idList.append(document.documentID)
                            self.questionList.append(document.data()["tablename"] as! String)
                            self.tagList.append(document.data()["tags"] as! Array<String>)
                            self.userList.append(document.data()["userRef"] as! DocumentReference)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.semaphore.signal()
                }
            }
        }
    }
}
