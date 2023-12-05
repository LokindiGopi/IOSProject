//
//  HistoryTVC.swift
//  CashCraft
//
//  Created by Gopi Lokindi on 12/1/23.
//

import UIKit
import FirebaseDatabase

class HistoryTVC: UITableViewController {
    var expense =  Monthly( rent: 0, groceries: 0, utilites: 0, others: 0,state: "",annual_income: "")
    var datestring = ""
    private let database = Database.database().reference ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let components = UtilityConstants.username.components(separatedBy: "@")
        let user = components[0]
        // #warning Incomplete implementation, return the number of rows
        let keys = UtilityConstants.expenses1
        let currentKey = keys[user]
        if UtilityConstants.expenses1.isEmpty{
            return 0
        }
        else{
            return   Array(currentKey!.keys).count
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Historycell", for: indexPath)
        let components = UtilityConstants.username.components(separatedBy: "@")
        let user = components[0]
        let K = UtilityConstants.expenses1
        let currentK = K[user]
        print("currentK",currentK!)
        let keys = Array(currentK!.keys)
        print("keys ",keys)
            let currentKey = keys[indexPath.row]
        print("currentKey ",currentKey)
        cell.textLabel?.text = currentKey
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let components = UtilityConstants.username.components(separatedBy: "@")
        let user = components[0]
        let K = UtilityConstants.expenses1
        let currentK = K[user]
        print("currentK",currentK!)
        let keys = Array(currentK!.keys)
        print("keys ",keys)
            let currentKey = keys[indexPath.row]
        datestring = currentKey
        print("currentKey ",currentKey)
                if   let secondData = UtilityConstants.expenses1[user]?[currentKey]{
                print("secondData ",secondData as Any)
                expense.rent = secondData[0].rent
                expense.groceries = secondData[0].groceries
                expense.utilites = secondData[0].utilites
                expense.others = secondData[0].others
                expense.state = secondData[0].state
                expense.annual_income = secondData[0].annual_income
                
                print(secondData[0].rent,"  ",secondData[0].groceries,"  ", secondData[0].utilites,"  ", secondData[0].others,"  ",secondData[0].state,"  ",secondData[0].annual_income )

            } else {
                print("No second value found for \(currentKey)")
            }
        self.performSegue(withIdentifier: "Updatesegue", sender: self)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _,_,_ in
            let components = UtilityConstants.username.components(separatedBy: "@")
            let user = components[0]
            let K = UtilityConstants.expenses1
            let currentK = K[user]
            let keys = Array(currentK!.keys)
                let currentKey = keys[indexPath.row]
            self.database.child(components[0]).child(currentKey).setValue (nil)
            if var firstDictionary = UtilityConstants.expenses1[components[0]] {
                firstDictionary[currentKey] = nil
                UtilityConstants.expenses1[components[0]] = firstDictionary
            } else {
                print("Key '\(components[0])' not found in expenses1")
            }
            tableView.reloadData()
            print("--------------------History",UtilityConstants.expenses1)
        }
       
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfig.performsFirstActionWithFullSwipe = true
        
        return swipeConfig
    }
    
   
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier , identifier == "Updatesegue" else {return}
        guard let destvc=segue.destination as? UpdateExpensesVC else {return}
        destvc.selecteditem = expense
        destvc.datestring =  datestring
    }


}
