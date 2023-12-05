//
//  HomeVC.swift
//  CashCraft
//
//  Created by Gopi Lokindi on 11/20/23.
//

import UIKit
import FirebaseAuth





class HomeVC: UIViewController {
     var username = ""

    
    @IBOutlet weak var Accountbtn: UIButton!
    
    @IBOutlet weak var ExpenseBtn: UIButton!
    
    @IBOutlet weak var Goals: UIButton!
    
    @IBOutlet weak var Dummybtn: UIButton!
    
    
    @IBOutlet weak var Historybtn: UIButton!
    
    
    @IBAction func LogoutBtn(_ sender: UIButton) {
        try! Auth.auth().signOut()
        UtilityConstants.expenses1 = [:]
        print("home",UtilityConstants.expenses1)
        
        //Logic: if user click logout button ,it goes main landing page.
        if let storyboard = self.storyboard {
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "login")
            if let navigationController = self.navigationController {
                navigationController.setViewControllers([loginViewController], animated: false)
            }
        }

        }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UtilityConstants.username = username
    }
   
   

}
