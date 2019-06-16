//
//  AllQTableViewController.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/15.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit
import Firebase

class AllQTableViewController: UITableViewController {
    var questionList:[String] = []
    var tagList = [Array<String>]()
    var idList:[String] = []
    var userList:[DocumentReference] = []
    var db : Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "matrix-356024_640")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height))
        imageView.image = image
        self.tableView.backgroundView = imageView
        tableView.register(UINib(nibName: "AllQTableViewCell", bundle: nil),forCellReuseIdentifier:"allCell")
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableView.automaticDimension
        db = Firestore.firestore()
        readData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return idList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allCell", for: indexPath) as! AllQTableViewCell
        var newTags:[String] = []
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
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let selectedquestion = indexPath.row
        self.performSegue(withIdentifier: "moveToAllQ", sender: selectedquestion)
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
                playViewController.flag = 3
            }
        }
    }

}
extension AllQTableViewController{
    func readData(){
        db.collection("userquestions").order(by: "createdAt", descending: true).getDocuments() { (querySnapshot, err) in
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
            self.tableView.reloadData()
        }
    }
}
