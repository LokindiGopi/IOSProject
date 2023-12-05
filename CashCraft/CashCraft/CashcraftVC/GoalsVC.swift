//
//  GoalsVC.swift
//  CashCraft
//
//  Created by Gopi Lokindi on 11/21/23.
//

import UIKit
import CoreML
import AVFAudio

class GoalsVC: UIViewController {
    
    var price = 0
    var tagvalue = 0
    var expense =  Monthly(rent: 0, groceries: 0, utilites: 0, others: 0,state: "",annual_income: "")
    
    @IBOutlet var Goals: [GoalV]!
    
    var audioPlayer: AVAudioPlayer?
    
    let img = UtilityConstants.images
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let path = Bundle.main.path(forResource: "Bleep", ofType: "mp3") else {
                    print("Sound file not found")
                    return
                }

                let url = URL(fileURLWithPath: path)

                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                } catch {
                    print("Error loading sound file: \(error.localizedDescription)")
                }

        let components = UtilityConstants.username.components(separatedBy: "@")
       
        if UtilityConstants.isUserNameExists(UtilityConstants.username) {
            print("User exists in expenses array!")
            print("expenses1   ",UtilityConstants.expenses1[components[0]]!)
          
            if let adminValues = UtilityConstants.expenses1[components[0]],
                let latestDateKey = adminValues.keys.max(),
                let latestDateValues = adminValues[latestDateKey],
               let latestMonthly = latestDateValues.first {
                expense = latestMonthly
            }

            }
        
        // Do any additional setup after loading the view.
        for i in 0..<6 {
            product(tagvalue: i)
            let tap = UITapGestureRecognizer(target: self, action: #selector(HandleTap(_:)))
            tap.numberOfTapsRequired = 2
            Goals[i].addGestureRecognizer(tap)
        }
        
    }
    
    func product(tagvalue:Int){
        let x = Goals[tagvalue]
        x.GoalImage.image = UIImage(named: UtilityConstants.images[tagvalue])
        x.GoalName.text = UtilityConstants.images[tagvalue]
    }
    
    
    @objc func HandleTap(_ sender: UITapGestureRecognizer){
        //playing sound
        
        audioPlayer?.play()
        if let tappedGoal = sender.view as? GoalV {
                tagvalue = tappedGoal.tag
                print("Goal tapped! Tag value: \(tagvalue)")
            }
       
        

        let alert = UIAlertController(title: "Enter amount", message: "", preferredStyle: .alert
        )
        alert.addTextField(configurationHandler: {
            field in
            field.placeholder = "Price"
            field.returnKeyType = .next
            field.keyboardType = .numberPad
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
          //reading text fields
            guard let fields = alert.textFields else{return}
            guard let price = fields[0].text , !price.isEmpty else{return}
            self.price = self.price+Int(price)!
            
            let summaryItem1 = Summary(image: UtilityConstants.images[self.tagvalue], goal: UtilityConstants.images[self.tagvalue])
            print(UtilityConstants.summary)
            print("Goals page",summaryItem1)
            if var userSummary = UtilityConstants.summary[UtilityConstants.username] {
                // If the key (username) already exists, append the new value
                print("user sumary",userSummary)
                var c = 0
                for i in userSummary{
                    if i.image == summaryItem1.image{
                        c = c+1
                    }
                   
                }
                if c == 0{
                        userSummary.append(summaryItem1)
                }
               
                UtilityConstants.summary[UtilityConstants.username] = userSummary
            } else {
                // If the key doesn't exist, create a new entry
                UtilityConstants.summary[UtilityConstants.username] = [summaryItem1]
            }
            
            self.performSegue(withIdentifier: "goalssummarySegue", sender: self)
            
        }))
        present(alert,animated: true)
        mlModel()
    }
    
    
    
    func mlModel(){
        
        let components = UtilityConstants.username.components(separatedBy: "@")
        if let value = UtilityConstants.expenses1[components[0]], value.isEmpty {
           return
        }
        else{
            do {
                print("----------------------ML-------------------",expense.annual_income)
                print(expense.state)
                
                let object = try GoalsPrediction(configuration: MLModelConfiguration())
                guard let prediction = try? object.prediction(input: GoalsPredictionInput(State: expense.state, Annual_income: Double(expense.annual_income)!))else{return}
                UtilityConstants.predicted_Savings = abs(Int(prediction.Savings)/10)
                print("predicted savings ",UtilityConstants.predicted_Savings)
            } catch let error {
                print(error)
            }
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier , identifier == "goalssummarySegue" else {return}
        guard let destvc=segue.destination as? SummaryTVC else {return}
        destvc.price = price
//        destvc.user = expense.user
    }
    

}
