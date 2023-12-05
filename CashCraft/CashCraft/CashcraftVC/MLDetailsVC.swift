//
//  MLDetailsVC.swift
//  CashCraft
//
//  Created by Gopi Lokindi on 11/22/23.
//

import UIKit

class MLDetailsVC: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var textlbl: UILabel!
    
    @IBOutlet weak var textview: UITextView!
    var price = 0
    var user = ""
    var check = false
    var selectedrow = 0
    var  selecteditem = Summary(image: "", goal: "")
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.image.image = UIImage(named: selecteditem.image)
        self.textlbl.text = selecteditem.goal
        self.textview.backgroundColor = UIColor(white: 1, alpha: 0.5)

        if price<UtilityConstants.predicted_Savings{
         check = true
        }
        else{
            UtilityConstants.amount = abs(price-UtilityConstants.predicted_Savings)
        }
        
        print(selectedrow)
        if(selectedrow == 0 && check != true){
            self.textview.text = "As predicted saving for selected state is $\(UtilityConstants.predicted_Savings)\n & Cumlative difference in amount $\(UtilityConstants.amount) to achieve your goal"
        }
        else if (check == true ){
            self.textview.text = "your predicted saving for your state is $\(UtilityConstants.predicted_Savings)\nyour goal amount is less than your savings so you achieve your goal easily"
        }else{
            self.textview.text = "your predicted saving for your state is $\(UtilityConstants.predicted_Savings)\n , so you need this amount $\(UtilityConstants.amount+price) to reach your goal"
        }
        
        
        
        // Do any additional setup after loading the view.
        
    }
    
    
  
    
}
