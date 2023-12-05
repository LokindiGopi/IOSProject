//
//  Model.swift
//  CashCraft
//
//  Created by Gopi Lokindi on 11/20/23.
//

import Foundation

//struct of the Monthlyexp of the user
struct Monthlyexp {
    var user : String
    var rent: Int
    var groceries: Int
    var utilites: Int
    var others: Int
    var state : String
    var annual_income : String
}

struct Monthly{
    var rent: Int
    var groceries: Int
    var utilites: Int
    var others: Int
    var state : String
    var annual_income : String
}

struct Summary{
    var image:String
    var goal : String
}
struct UtilityConstants{
    
    
    static let states = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District of Columbia","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Puerto Rico","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
    
    //predicted value
    static var predicted_Savings = 0
    
    // amount
    
    static var amount = 0
    //images
    static let images:[String] = ["House","Education","car","baby","Shopping","Entertainment"]
    
    
    static var expenses1 : [String: [String :[Monthly]]] = [:]
    //monthly expense of each user
    static var expenses :[Monthlyexp] = [
//        Monthlyexp(user: "admin@gmail.com" , rent: 300, groceries: 50, utilites: 150, others: 400,state:"Alabama",annual_income: "419988"),
//        Monthlyexp(user: "hello@gmail.com", rent: 800, groceries: 100, utilites: 250, others: 1000,state:"Colorado",annual_income: "1799988"),
//        Monthlyexp(user: "ramu@gmail.com", rent: 300, groceries: 50, utilites: 150, others: 400,state:"Colorado",annual_income: "1799988"),
//        Monthlyexp(user: "alien@gmail.com", rent: 300, groceries: 50, utilites: 150, others: 400,state:"Florida",annual_income: "479988"),
//        Monthlyexp(user: "kiran@gmail.com", rent: 300, groceries: 50, utilites: 150, others: 400,state:"Florida",annual_income: "719988")
    ]
    
    static var summary : [String :[Summary]] = [:]
    
    
    static var username = ""
    
    static func isUserNameExists(_ userName: String) -> Bool {
           let matchingExpenses = expenses1.filter { monthlyExp in
               print("---------------------\n",monthlyExp.key)
               return "\(monthlyExp.key)@gmail.com" == userName
           }

           return !matchingExpenses.isEmpty
       }
}
