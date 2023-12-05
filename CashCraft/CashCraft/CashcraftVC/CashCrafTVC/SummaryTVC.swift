//
//  SummaryTVC.swift
//  CashCraft
//
//  Created by Gopi Lokindi on 11/22/23.
//

import UIKit

class SummaryTVC: UITableViewController {

    
    var price = 0
        var user = ""
        var  selecteditem = Summary(image: "", goal: "")
        var selectedrow = 0
        override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let specificKey = UtilityConstants.username
        if let itemsForSpecificKey = UtilityConstants.summary[specificKey] {
            let itemCount = itemsForSpecificKey.count
            print("Count for \(specificKey): \(itemCount)")
            return itemCount
        } else {
            print("Key not found in summary dictionary")
            return 0
        }

       
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _,_,_ in
            let username = UtilityConstants.username
            if var userSummary = UtilityConstants.summary[username], !userSummary.isEmpty {
                guard indexPath.row < userSummary.count else {
                    return
                }
                userSummary.remove(at: indexPath.row)
                UtilityConstants.summary[username] = userSummary
            }
            tableView.reloadData()
        }
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfig.performsFirstActionWithFullSwipe = true
        
        return swipeConfig
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "summary", for: indexPath)
        print(UtilityConstants.summary)
        print(UtilityConstants.username)
        let username = UtilityConstants.username
        if let userSummary = UtilityConstants.summary[username], !userSummary.isEmpty {
            let summaryItem = userSummary[indexPath.row]
            cell.textLabel?.text = summaryItem.goal
            cell.imageView?.image = UIImage(named: summaryItem.image)
        }

        return cell
    }
    


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedrow = indexPath.row
        let username = UtilityConstants.username
        if let userSummary = UtilityConstants.summary[username], !userSummary.isEmpty {
            let summaryItem = userSummary[indexPath.row]
            selecteditem = summaryItem
        }
        
        self.performSegue(withIdentifier: "MldetailsSegue", sender: self)
    }

    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier , identifier == "MldetailsSegue" else {return}
        guard let destvc=segue.destination as? MLDetailsVC else {return}
        destvc.selecteditem = selecteditem
        destvc.price = price
        destvc.user = user
        destvc.selectedrow = selectedrow
    }
 

}
