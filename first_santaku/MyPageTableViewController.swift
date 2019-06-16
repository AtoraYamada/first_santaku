//
//  MyPageTableViewController.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/13.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit
import Firebase

class MyPageTableViewController: UITableViewController {
    var questionList:[String] = []
    var tagList = [Array<String>]()
    var idList:[String] = []
    let user = Auth.auth().currentUser
    var db : Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "matrix-356024_640")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height))
        imageView.image = image
        self.tableView.backgroundView = imageView
        tableView.register(UINib(nibName: "MyPageTableViewCell", bundle: nil),forCellReuseIdentifier:"mypageCell")
        tableView.estimatedRowHeight = 86
        tableView.rowHeight = UITableView.automaticDimension
        db = Firestore.firestore()
        readData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var newTags:[String] = []
        let cell = tableView.dequeueReusableCell(withIdentifier: "mypageCell", for: indexPath) as! MyPageTableViewCell
        let selectedquestion = self.questionList[indexPath.row]
        cell.mypageTitle.text = selectedquestion
        let selectedtags = self.tagList[indexPath.row]
        for tag in selectedtags{
            newTags.append("#\(tag)")
        }
        cell.mypageTags.text = newTags.joined(separator: " ")
        cell.mypageTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.mypageTitle.font = UIFont(name: "Kefa", size: 22)
        cell.mypageTags.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.mypageTags.font = UIFont(name: "Kefa", size: 15)
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let selectedquestion = indexPath.row
        self.performSegue(withIdentifier: "moveToMyQuestion", sender: selectedquestion)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let playViewController = segue.destination as? PlayViewController{
            if let selectedquestion = sender as? Int{
                playViewController.selectedQ = selectedquestion
                playViewController.flag = 2
            }
        }
    }

}
extension MyPageTableViewController{
    func readData(){
        db.collection("users").document("\(self.user!.uid)").collection("userquestions").order(by: "createdAt", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.idList.append(document.documentID)
                    self.questionList.append(document.data()["tablename"] as! String)
                    self.tagList.append(document.data()["tags"] as! Array<String>)
                }
            }
            self.tableView.reloadData()
        }
    }
}
