//
//  StatusTableViewController.swift
//  Comedy Notes
//
//  Created by Anna Shark on 9/9/21.
//

import UIKit
import CoreData

class StatusTableViewController: UITableViewController {
    var statusArray = ["In progress", "Finished"]

    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell", for: indexPath)
        cell.textLabel?.text = statusArray[indexPath.row]
        return cell
    }

    //MARK: - TableView Delegate methods
        //leave for later what should happen when we click category
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "goToJokes", sender: self)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as! JokesTableViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                print(statusArray[indexPath.row])
                if statusArray[indexPath.row] == "Finished"{
                    destinationVC.selectedStatus = true
                }
                else if statusArray[indexPath.row] == "In progress" {
                    destinationVC.selectedStatus = false
                }
            }
        }

}
