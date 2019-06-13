//
//  AnswerTableViewController.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/13.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit

class AnswerTableViewController: UITableViewController {
    var questions = [Array<String>]()
    var answers = Array<Int>()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AnswerTableViewCell", bundle: nil),forCellReuseIdentifier:"answerCell")
        tableView.estimatedRowHeight = 309
        tableView.rowHeight = UITableView.automaticDimension
        }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

         let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath) as! AnswerTableViewCell
        let question = questions[indexPath.row]
        cell.問題文?.text = question[0]
        cell.userAnswer?.text = question[answers[indexPath.row]]
        cell.correctAnswer?.text = question[1]
        cell.解説?.text = question[4]
        return cell
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

}
