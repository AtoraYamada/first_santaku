//
//  MainTableViewController.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/10.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit
import Firebase

class MainTableViewController: UITableViewController {
    var db : Firestore!
    var idList:[String] = []
    var questionList:[String] = []
   
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "top")
            self.present(storyboard, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "matrix-356024_640")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height))
        imageView.image = image
        self.tableView.backgroundView = imageView
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
