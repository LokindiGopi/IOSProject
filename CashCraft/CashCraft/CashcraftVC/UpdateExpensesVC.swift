//
//  UpdateExpensesVC.swift
//  CashCraft
//
//  Created by Gopi Lokindi on 12/4/23.
//

import UIKit
import FirebaseDatabase

class UpdateExpensesVC: UIViewController {
    var selecteditem = Monthly( rent: 0, groceries: 0, utilites: 0, others: 0,state: "",annual_income: "")
    var expense =  Monthly(rent: 0, groceries: 0, utilites: 0, others: 0,state: "",annual_income: "")
    var statelbl = ""
    var datestring = ""
    private let database = Database.database().reference ()
    
    @IBOutlet weak var rentlbl: UITextField!
    
    @IBOutlet weak var grocerieslbl: UITextField!
    
    @IBOutlet weak var utiliteslbl: UITextField!
    
    @IBOutlet weak var otherslbl: UITextField!
    
    
    @IBOutlet weak var statePV: UIPickerView!
    
    @IBOutlet weak var income: UITextField!
    
    @IBAction func UpdateData(_ sender: UIButton) {
        
        let components = UtilityConstants.username.components(separatedBy: "@")
        let object: [String: Any] = [
            "rent": Int(self.rentlbl.text!)! as NSObject,
            "groceries": Int(self.grocerieslbl.text!)!,
            "utilites":  Int(self.utiliteslbl.text!)!,
            "others": Int(self.otherslbl.text!)!,
            "state":  self.statelbl,
            "annual_income": self.income.text!
        ]
        
        database.child(components[0]).child(datestring).setValue (object)
        let alertmsg = UIAlertController(title: "updation", message: "Data has been updated in FB", preferredStyle: .alert)
        alertmsg.addAction(UIAlertAction(title: "OK" , style:.default ,handler: { action in
            self.rentlbl.text = ""
            self.grocerieslbl.text = ""
            self.utiliteslbl.text = ""
            self.otherslbl.text = ""
            self.statePV.selectRow(0, inComponent:0, animated:true)
            self.income.text = ""
        }))
        self.present(alertmsg, animated: true, completion: nil)
        
        rentlbl.placeholder = rentlbl.text
        grocerieslbl.placeholder = grocerieslbl.text
        otherslbl.placeholder = otherslbl.text
        utiliteslbl.placeholder = utiliteslbl.text
        var index = UtilityConstants.states.firstIndex(of: statelbl)
        if index == nil{
            index = 0
        }
        self.statePV.selectRow(index!, inComponent:0, animated:true)
        income.placeholder = income.text
        let user = components[0]
        if let rentText = self.rentlbl.text, let rentValue = Int(rentText) {
            expense.rent = rentValue
        }
        if let groceText = self.grocerieslbl.text, let Value = Int(groceText) {
            expense.groceries = Value
        }
        if let utilityText = self.utiliteslbl.text, let Value = Int(utilityText) {
            expense.utilites = Value
        }
        if let otherText = self.otherslbl.text, let Value = Int(otherText) {
            expense.others = Value
        }
        expense.state = statelbl
        expense.annual_income = income.text!
        UtilityConstants.expenses1[user]![self.datestring]![0] = self.expense
        print("expenses ",expense)
        print(" main \n",UtilityConstants.expenses1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statePV.delegate = self
        self.statePV.dataSource = self
        rentlbl.placeholder = "\(selecteditem.rent)"
        grocerieslbl.placeholder = "\(selecteditem.groceries)"
        otherslbl.placeholder = "\(selecteditem.others)"
        utiliteslbl.placeholder = "\(selecteditem.utilites)"
        
        self.rentlbl.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.grocerieslbl.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.utiliteslbl.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.otherslbl.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.statePV.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.income.backgroundColor = UIColor(white: 1, alpha: 0.5)
        var index = UtilityConstants.states.firstIndex(of: selecteditem.state)
        if index == nil{
            index = 0
        }
        self.statePV.selectRow(index!, inComponent:0, animated:true)
        income.placeholder = "\(selecteditem.annual_income)"
        
    }
    
    
}
extension UpdateExpensesVC : UIPickerViewDelegate,UIPickerViewDataSource{
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
