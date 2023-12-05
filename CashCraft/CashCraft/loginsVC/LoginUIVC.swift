//
//  LoginUIVC.swift
//  CashCraft
//
//  Created by Gopi Lokindi on 11/20/23.
//

import UIKit
import Lottie
import FirebaseAuth
import AVFoundation
import FirebaseDatabase

class LoginUIVC: UIViewController {
    var username = ""
    var expense =  Monthly( rent: 0, groceries: 0, utilites: 0, others: 0,state: "",annual_income: "")
    private let database = Database.database().reference ()
    var audioPlayer: AVAudioPlayer?
    @IBOutlet weak var logoAnimationView: LottieAnimationView!
    
    @IBOutlet weak var UsernameLBl: UITextField!
    
    @IBOutlet weak var PasswordLBL: UITextField!
    
    @IBOutlet weak var Activityindicator: UIActivityIndicatorView!
    
    @IBAction func LoginBtn(_ sender: UIButton) {
        guard let email = UsernameLBl.text ,!email.isEmpty else {
            let alertmsg = UIAlertController(title: "Error Message", message: "enter a username field", preferredStyle: .alert)
            alertmsg.addAction(UIAlertAction(title: "Yes" , style: .destructive))
            self.present(alertmsg, animated: true, completion: nil)

            return}
        guard let password = PasswordLBL.text,!password.isEmpty else {
            let alertmsg = UIAlertController(title: "Error Message", message: "enter a password field", preferredStyle: .alert)
            alertmsg.addAction(UIAlertAction(title: "Yes" , style: .destructive))
            self.present(alertmsg, animated: true, completion: nil)
            return
        }
        AudioServicesPlaySystemSound(SystemSoundID(1306))
        self.username = email
        Activityindicator.startAnimating()
        //logic for user logins validating
        Auth.auth().signIn(withEmail: email, password: password) { firebaseResult , error in
            self.Activityindicator.stopAnimating()
            if let e = error{
                print("error",e)
                let alertmsg = UIAlertController(title: "Error Message", message: "Invalid Credentials", preferredStyle: .alert)
                alertmsg.addAction(UIAlertAction(title: "Yes" , style: .destructive))
                self.present(alertmsg, animated: true, completion: nil)
                print("invalid logins")
            }
            else{
               
                self.performSegue(withIdentifier: "homeSegue", sender: self)
                
            }
        }
        pulldata()
        self.UsernameLBl.text = ""
        self.PasswordLBL.text = ""
    }
    
    @IBAction func ResetBtn(_ sender: UIButton) {
        audioPlayer?.play()
        self.UsernameLBl.text = ""
        self.PasswordLBL.text = ""
    }
    
    
    
    let animationView = LottieAnimationView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logoAnimationView.backgroundColor = UIColor(white: 1, alpha: 0)

        
        //lotto animation logic
        logoAnimationView.animation=LottieAnimation.named("LoginAnimation")
        logoAnimationView.play()
        logoAnimationView.loopMode = .loop
        
        //sound logic
        guard let path = Bundle.main.path(forResource: "Reset", ofType: "mp3") else {
                    print("Sound file not found")
                    return
                }

                let url = URL(fileURLWithPath: path)

                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                } catch {
                    print("Error loading sound file: \(error.localizedDescription)")
                }
         
        
    }
    

  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UtilityConstants.username = username
        guard let identifier = segue.identifier , identifier == "homeSegue" else {return}
        guard let destvc=segue.destination as? HomeVC else {return}
        destvc.username = username
    }
  

    //data is pulling from Firebase if user exists
    func pulldata(){
        let components = self.UsernameLBl.text!.components(separatedBy: "@")
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
    
}
