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
    var db : Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "matrix-356024_640")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height))
        imageView.image = image
        self.tableView.backgroundView = imageView
        tableView.register(UINib(nibName: "AllQTableViewCell", bundle: nil),forCellReuseIdentifier:"allCell")
        tableView.estimatedRowHeight = 91
        tableView.rowHeight = UITableView.automaticDimension
        db = Firestore.firestore()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allCell", for: indexPath) as! AllQTableViewCell
        cell.allTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.allTitle.font = UIFont(name: "Kefa", size: 22)
        cell.allTags.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.allTags.font = UIFont(name: "Kefa", size: 15)
        cell.allName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.allName.font = UIFont(name: "Kefa", size: 15)
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        return cell
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

}
