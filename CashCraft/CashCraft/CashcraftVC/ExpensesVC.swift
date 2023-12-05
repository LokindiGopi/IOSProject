//
//  ExpensesVC.swift
//  CashCraft
//
//  Created by Gopi Lokindi on 11/21/23.
//

import UIKit
import FirebaseDatabase

class ExpensesVC: UIViewController {
    
    private let database = Database.database().reference ()
    var statelbl = ""
    @IBOutlet weak var titlelbl: UILabel!
    
    @IBOutlet weak var rentlbl: UITextField!
    @IBOutlet weak var grocerieslbl: UITextField!
    @IBOutlet weak var utiliteslbl: UITextField!
    @IBOutlet weak var otherlbl: UITextField!
    
    @IBOutlet weak var incomelbl: UITextField!
    
    @IBOutlet weak var stateview: UIPickerView!
    
    var expense =  Monthly(rent: 0, groceries: 0, utilites: 0, others: 0,state: "",annual_income: "")
    let username = UtilityConstants.username
    
    @IBAction func Submitbtn(_ sender: UIButton) {
        
        //validations
        guard let rent = rentlbl.text, !rent.isEmpty,isNumeric(rent) else{
            let alertmsg = UIAlertController(title: "Error", message: "enter a rent field and must numeric value.", preferredStyle: .alert)
            alertmsg.addAction(UIAlertAction(title: "OK" , style:.default ,handler: { action in
                
            }))
            self.present(alertmsg, animated: true, completion: nil)
            return
        }
        
        guard let grocery = grocerieslbl.text, !grocery.isEmpty,isNumeric(grocery) else{
            let alertmsg = UIAlertController(title: "Error", message: "enter a grocery field and must numeric value.", preferredStyle: .alert)
            alertmsg.addAction(UIAlertAction(title: "OK" , style:.default ,handler: { action in
                
            }))
            self.present(alertmsg, animated: true, completion: nil)
            return
        }
        
        guard let utilites = utiliteslbl.text, !utilites.isEmpty,isNumeric(utilites) else{
            let alertmsg = UIAlertController(title: "Error", message: "enter a utilites field and must numeric value.", preferredStyle: .alert)
            alertmsg.addAction(UIAlertAction(title: "OK" , style:.default ,handler: { action in
                
            }))
            self.present(alertmsg, animated: true, completion: nil)
            return
        }
        
        guard let other = otherlbl.text, !other.isEmpty,isNumeric(other) else{
            let alertmsg = UIAlertController(title: "Error", message: "enter a other field and must numeric value.", preferredStyle: .alert)
            alertmsg.addAction(UIAlertAction(title: "OK" , style:.default ,handler: { action in
                
            }))
            self.present(alertmsg, animated: true, completion: nil)
            return
        }
        
        guard let income = incomelbl.text, !income.isEmpty,isNumeric(income) else{
            let alertmsg = UIAlertController(title: "Error", message: "enter a income field and must numeric value.", preferredStyle: .alert)
            alertmsg.addAction(UIAlertAction(title: "OK" , style:.default ,handler: { action in
                
            }))
            self.present(alertmsg, animated: true, completion: nil)
            return
        }
        
        
        let currentTimeStamp = Date().timeIntervalSince1970

        // Convert the timestamp to a string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let  dateString = dateFormatter.string(from: Date(timeIntervalSince1970: currentTimeStamp))
        print("Current Timestamp: \(currentTimeStamp)")
        print("Formatted Date String: \(dateString)")

        let components = self.username.components(separatedBy: "@")
        let object: [String: Any] = [
            "rent": Int(self.rentlbl.text!)! as NSObject,
            "groceries": Int(self.grocerieslbl.text!)!,
            "utilites":  Int(self.utiliteslbl.text!)!,
            "others": Int(self.otherlbl.text!)!,
            "state":  self.statelbl,
            "annual_income": self.incomelbl.text!
        ]

        database.child(components[0]).child(dateString).setValue (object)
        let alertmsg = UIAlertController(title: "Submission", message: "Data has been stored in FB", preferredStyle: .alert)
        alertmsg.addAction(UIAlertAction(title: "OK" , style:.default ,handler: { action in
            self.rentlbl.text = ""
            self.grocerieslbl.text = ""
            self.utiliteslbl.text = ""
            self.otherlbl.text = ""
            self.stateview.selectRow(0, inComponent:0, animated:true)
            self.incomelbl.text = ""
        }))
        self.present(alertmsg, animated: true, completion: nil)
        
        
        pulldata()
        
    }
    
    func pulldata(){
        let components =  UtilityConstants.username.components(separatedBy: "@")
        let user = components[0]
        database.child(components[0]).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else{
                return
            }
            
            print("Value: \(value)")
            var date = ""
            if UtilityConstants.expenses1[user] == nil {
                UtilityConstants.expenses1[user] = [:]
            }

            for (dateString, data) in value {
                if let dateData = data as? [String: Any],
                   let annualIncome = dateData["annual_income"] as? String,
                   let groceries = dateData["groceries"] as? Int,
                   let others = dateData["others"] as? Int,
                   let rent = dateData["rent"] as? Int,
                   let state = dateData["state"] as? String,
                   let utilities = dateData["utilites"] as? Int {
                    date = dateString
                    self.expense.rent = rent
                    self.expense.groceries = groceries
                    self.expense.utilites = utilities
                    self.expense.others = others
                    self.expense.state = state
                    self.expense.annual_income = annualIncome
                    if UtilityConstants.expenses1[user]?[date] == nil {
                        UtilityConstants.expenses1[user]?[date] = []
                    }
                    UtilityConstants.expenses1[user]?[date]?.append(self.expense)

                    // Print the entire dictionary
                    print("Utility Expenses1:-----------", UtilityConstants.expenses1)
                            
                }}
        })
    }
    
    
            
            
            
  func isNumeric(_ input: String) -> Bool {
        let numericRegex = "^[0-9]+$"
        let numericTest = NSPredicate(format: "SELF MATCHES %@", numericRegex)
        return numericTest.evaluate(with: input)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stateview.delegate = self
        self.stateview.dataSource = self
        self.titlelbl.text = "Enter the Average Expenses"
        self.rentlbl.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.grocerieslbl.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.utiliteslbl.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.otherlbl.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.stateview.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.incomelbl.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
    }
    
    
}
extension ExpensesVC : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return UtilityConstants.states.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return UtilityConstants.states[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        statelbl = UtilityConstants.states[row]
    }
}

