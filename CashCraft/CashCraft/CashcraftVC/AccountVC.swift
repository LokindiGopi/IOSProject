//
//  AccountVC.swift
//  CashCraft
//
//  Created by Gopi Lokindi on 11/21/23.
//

import UIKit
import Charts
import DGCharts

class AccountVC: UIViewController,ChartViewDelegate {
    var selecteditem = ""
    var trackxpense : [String:[Monthly]] = ["": [Monthly( rent: 0, groceries: 0, utilites: 0, others: 0,state: "",annual_income: "")]]
    let players = ["Rent","groceries","Utilites","Others"]
    var goals = [Int]()

    @IBOutlet weak var dropdown: UIButton!
    
    @IBAction func selectBtn(_ sender: UIButton) {
        if tableV.isHidden{
            animate(toggle: true)
        }
        else{
            animate(toggle: false)
        }
    }
    
    func animate(toggle: Bool){
        if toggle{
            UIView.animate(withDuration: 0.3){
                self.tableV.isHidden = false
            }
        }
        else{
            UIView.animate(withDuration: 0.3){
                self.tableV.isHidden = true
            }
        }
    }
    @IBOutlet weak var tableV: UITableView!
    
    
    @IBOutlet weak var PiechartView: UIView!
    
    var piechart = PieChartView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableV.delegate = self
        tableV.isHidden = true
        chartchanging()
        self.tableV.backgroundColor = UIColor(white: 1, alpha: 0)
        self.PiechartView.backgroundColor = UIColor(white: 1, alpha: 0)

    }
    
    
    
    override func viewWillLayoutSubviews() {
           super.viewWillLayoutSubviews()
           updatePieChartFrame()
       }
    
      // logic : updating piechart view for landscape mode
       func updatePieChartFrame() {
           let pieChartWidth = min(self.PiechartView.frame.size.width, self.PiechartView.frame.size.height)
           let pieChartHeight = max(self.PiechartView.frame.size.width, self.PiechartView.frame.size.height)
           piechart.frame = CGRect(x: 0, y: 0, width: pieChartWidth, height: pieChartHeight)
       }
    
    func chartchanging(){
        print("-----------",UtilityConstants.username)
       let components = UtilityConstants.username.components(separatedBy: "@")
        piechart.frame = CGRect(x: 0, y: 0, width: Int(self.PiechartView.frame.size.width), height: Int(self.PiechartView.frame.size.height))
        PiechartView.addSubview(piechart)

        
        if let value = UtilityConstants.expenses1[components[0]], value.isEmpty {
           return 
        }
        else{
            if UtilityConstants.isUserNameExists(UtilityConstants.username){
                print("User exists in expenses array!")
                print("expenses1   ",UtilityConstants.expenses1[components[0]]!)
                print(selecteditem)
                if !selecteditem.isEmpty{
                    if let adminValues = UtilityConstants.expenses1[components[0]],
                       let firstDateValues = adminValues[selecteditem],
                       let firstMonthly = firstDateValues.first {
                        trackxpense = adminValues
                        print("inside if loop")
                        goals.removeAll()
                        goals.append(firstMonthly.rent)
                        goals.append(firstMonthly.groceries)
                        goals.append(firstMonthly.utilites)
                        goals.append(firstMonthly.others)
                    }
                    print(goals)
                }
                else{
                    print("no selected item")
                    if let adminValues = UtilityConstants.expenses1[components[0]],
                       let firstDateValues = adminValues.values.first,
                       let firstMonthly = firstDateValues.first {
                        trackxpense = adminValues
                        goals.removeAll()
                        goals.append(firstMonthly.rent)
                        goals.append(firstMonthly.groceries)
                        goals.append(firstMonthly.utilites)
                        goals.append(firstMonthly.others)
                    }
                }
            } else {
                print("User does not exist in expenses array.")
                return
            }
        }
            
        customizeChart(dataPoints: players, values: goals.map{ Double($0) })
    }
    
    
    


    
    func customizeChart(dataPoints: [String], values: [Double]) {
      var dataEntries: [ChartDataEntry] = []
        if UtilityConstants.expenses1.isEmpty{
            return
        }
        else{
            for i in 0..<dataPoints.count {
                let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
                dataEntries.append(dataEntry)
            }
            // 2. Set ChartDataSet
            let pieChartDataSet = PieChartDataSet(entries: dataEntries,label: "Expenses")
            pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
            // 3. Set ChartData
            let pieChartData = PieChartData(dataSet: pieChartDataSet)
            let format = NumberFormatter()
            format.numberStyle = .none
            let formatter = DefaultValueFormatter(formatter: format)
            pieChartData.setValueFormatter(formatter)
            
            // 4. Assign it to the chart’s data
            piechart.data = pieChartData
        }
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
      var colors: [UIColor] = []
      for _ in 0..<numbersOfColor {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        colors.append(color)
      }
      return colors
    }
    

}

extension AccountVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackxpense.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Dropdowncell", for: indexPath)
        cell.textLabel?.text = Array(trackxpense.keys)[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selecteditem = Array(trackxpense.keys)[indexPath.row]
        print(selecteditem,"------------table")
        dropdown.setTitle("\(Array(trackxpense.keys)[indexPath.row])", for: .normal)
        animate(toggle: false)
        chartchanging()
    }
    
}
