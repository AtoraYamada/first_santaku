//
//  MainTableViewController.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/10.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class MainTableViewController: UITableViewController {
    var keyboard2 : AVAudioPlayer! = nil
    var keyboard1 : AVAudioPlayer! = nil
    var db : Firestore!
    var idList:[String] = []
    var questionList:[String] = []
   
    @IBAction func signOut(_ sender: Any) {
        keyboard1.currentTime = 0
        keyboard1.play()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "top")
            self.present(storyboard, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func moveToEdit(_ sender: Any) {
        keyboard1.currentTime = 0
        keyboard1.play()
        self.performSegue(withIdentifier: "edit", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "matrix-356024_640")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height))
        imageView.image = image
        self.tableView.backgroundView = imageView
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.items?.forEach { $0.isEnabled = true }
        readData()
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let selectedquestion = questionList[indexPath.row]
        cell.textLabel?.text = selectedquestion
        cell.textLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.textLabel!.font = UIFont(name: "Kefa", size: 22)
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        keyboard2.currentTime = 0
        keyboard2.play()
        let selectedquestion = indexPath.row
        self.performSegue(withIdentifier: "moveToQuestion", sender: selectedquestion)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let playViewController = segue.destination as? PlayViewController{
                if let selectedquestion = sender as? Int{
                    playViewController.selectedQ = selectedquestion
                    playViewController.flag = 1
                }
            }
    }
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
    }

}

extension MainTableViewController{
    func readData(){
        self.idList = []
        self.questionList = []
        db.collection("questions").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.idList.append(document.documentID)
                    self.questionList.append(document.data()["tablename"] as! String)
                }
            }
            self.tableView.reloadData()
        }
    }
}
