//
//  MainScreenViewController.swift
//  cache_app
//
//  Created by Kelly Williams on 5/6/18.
//  Copyright © 2018 ncgheorghe. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Charts
import UserNotifications


class MainScreenViewController: UIViewController {
    
    //notifications
    var isGrantedAccess = true;
    
    func addNotification(trigger:UNNotificationTrigger?, content:UNMutableNotificationContent, identifier:String){
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request){
            (error) in
            if error != nil {
                print("error adding notification:\(error?.localizedDescription)")
            }
        }
        
    }
    
    
    
    @IBOutlet weak var PieChart: PieChartView!
    
    //incomes labels
    @IBOutlet weak var grossIncomeLabel: UILabel!
    @IBOutlet weak var netIncomeLabel: UILabel!
    
    
    //state and city labels
    @IBOutlet weak var stateLabel: UILabel!
    var stateVar:String = ""
    @IBOutlet weak var cityLabel: UILabel!
    var cityVar:String = ""
    
    //taxes labels
    @IBOutlet weak var taxPercentLabel: UILabel!
    var taxPercentVar:Double = 0.0
    @IBOutlet weak var taxDollarLabel: UILabel!
    var taxDollarVar:Double = 0.0
    
    //rent and utilities labels
    @IBOutlet weak var rentPercentLabel: UILabel!
    var rentPercentVar:Double = 0.0
    @IBOutlet weak var rentDollarLabel: UILabel!
    var utilitiesDollarVar:Double = 0.0
    var rentDollarVar:Double = 0.0
    
    //loan payments labels
    @IBOutlet weak var loanPercentLabel: UILabel!
    var loanPercentVar:Double = 0.0
    @IBOutlet weak var loanDollarLabels: UILabel!
    var loanDollarVar:Double = 0.0
    
    //personal expenses label
    @IBOutlet weak var personalPercentLabel: UILabel!
    var personalPercentVar:Double = 0.0
    @IBOutlet weak var personalDollarLabel: UILabel!
    var personalDollarVar:Double = 0.0
    
    
    var dbReference : DatabaseReference?
    var dbHandle : DatabaseHandle?
    
    
    var stateAbbreviations = [
        "AL" : 0.3,         //ALABAMA           -- 1    -- 0.05
        "AK" : 0.25,        //ALASKA            -- 2    -- 0.00
        "AZ" : 0.2836,      //ARIZONA           -- 3    -- 0.0336
        "AR" : 0.319,       //ARKANSAS          -- 4    -- 0.069
        "CA" : 0.33,        //CALIFORNIA        -- 5    -- 0.08
        "CO" : 0.261575,    //COLORADO          -- 6    -- 0.011575
        "CT" : 0.3,         //CONNECTICUT       -- 7    -- 0.05
        "DE" : 0.3055,      //DELAWARE          -- 8    -- 0.0555
        "DC" : 0.315,       //DC                -- 8.5  -- 0.0650
        "FL" : 0.25,        //FLORIDA           -- 9    -- 0.00
        "GA" : 0.31,        //GEORGIA           -- 10   -- 0.06
        "HI" : 0.3325,      //HAWAII            -- 11   -- 0.0825
        "ID" : 0.324,       //IDAHO             -- 12   -- 0.074
        "IL" : 0.26125,     //ILLINOIS          -- 13   -- 0.01125
        "IN" : 0.258075,    //INDIANA           -- 14   -- 0.008075
        "IA" : 0.3292,      //IOWA              -- 15   -- 0.0792
        "KS" : 0.307,       //KANSAS            -- 16   -- 0.0570
        "KY" : 0.308,       //KENTUCKY          -- 17   -- 0.0580
        "LA" : 0.29,        //LOUISIANA         -- 18   -- 0.04
        "ME" : 0.3175,      //MAINE             -- 19   -- 0.0675
        "MD" : 0.2975,      //MARYLAND          -- 20   -- 0.0475
        "MA" : 0.301,       //MASSACHUSETTS     -- 21   -- 0.0510
        "MI" : 0.260625,    //MICHIGAN          -- 22   -- 0.010625
        "MN" : 0.3205,      //MINNESOTA         -- 23   -- 0.0705
        "MS" : 0.3,         //MISSISSIPPI       -- 24   -- 0.05
        "MO" : 0.309,       //MISSOURI          -- 25   -- 0.0590
        "MT" : 0.319,       //MONTANA           -- 26   -- 0.0690
        "NE" : 0.3184,      //NEBRASKA          -- 27   -- 0.0684
        "NV" : 0.25,        //NEVADA            -- 28   -- 0.00
        "NH" : 0.3,         //NEW HAMPSHIRE     -- 29   -- 0.05
        "NJ" : 0.30525,     //NEW JERSEY        -- 30   -- 0.05525
        "NM" : 0.299,       //NEW MEXICO        -- 31   -- 0.0490
        "NY" : 0.3133,      //NEW YORK          -- 32   -- 0.0633
        "NC" : 0.30499,     //NORTH CAROLINA    -- 33   -- 0.05499
        "ND" : 0.2704,      //NORTH DAKOTA      -- 34   -- 0.0204
        "OH" : 0.28465,     //OHIO              -- 35   -- 0.03465
        "OK" : 0.3,         //OKLAHOMA          -- 36   -- 0.05
        "OR" : 0.34,        //OREGON            -- 37   -- 0.09
        "PA" : 0.2807,      //PENNSYLVANIA      -- 38   -- 0.0307
        "RI" : 0.2875,      //RHODE ISLAND      -- 39   -- 0.0375
        "SC" : 0.32,        //SOUTH CAROLINA    -- 40   -- 0.07
        "SD" : 0.25,        //SOUTH DAKOTA      -- 41   -- 0.00
        "TN" : 0.28,        //TENNESSEE         -- 42   -- 0.03
        "TX" : 0.25,        //TEXAS             -- 43   -- 0.00
        "UT" : 0.3,         //UTAH              -- 44   -- 0.05
        "VT" : 0.318,       //VERMONT           -- 45   -- 0.0680
        "VA" : 0.3075,      //VIRGINIA          -- 46   -- 0.0575
        "WA" : 0.25,        //WASHINGTON        -- 47   -- 0.00
        "WV" : 0.31,        //WEST VIRGINIA     -- 48   -- 0.06
        "WI" : 0.3127,      //WISCONSIN         -- 49   -- 0.0627
        "WY" : 0.25         //WYOMING           -- 50   -- 0.00
    ]
    
    //variable to recieve email info from previous view controller
    var userEmail:String?
    
    
    var taxDataEntry = PieChartDataEntry()
    var rentDataEntry = PieChartDataEntry()
    var loanDataEntry = PieChartDataEntry()
    var personalDataEntry = PieChartDataEntry()
    
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //pie chart description
        dbReference = Database.database().reference()
        //notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (granted, error) in
            self.isGrantedAccess = granted
            if !granted {
                //add alert to complain to user
            }
        }
        
        let content = UNMutableNotificationContent();
        
        content.title = "Important Financial Day:"
        content.body = "Tax Day is in 2 Weeks!"
        UNNotificationSound.default()
        
        var dateInfo = DateComponents()
        dateInfo.month = 4
        dateInfo.weekday = 15
        dateInfo.hour = 7
        dateInfo.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        
        // Create the request object.
        let request = UNNotificationRequest(identifier: "taxday", content: content, trigger: trigger)
        
        //get all the data as a dictionary and handle everything inside one closure
        
        dbHandle = dbReference?.child("users").child(userEmail!).observe(.value, with: { (snapshot) in
            if !snapshot.exists(){
                //handle case where data isn't found
                return
            } //else:
            
            //capture the data all at once as a dictionary
            let userData = snapshot.value as! [String: Any]
            
            //capture the city
            guard let userCity = userData["city"] as! String? else{
                print("No city info found for the user")
                return
            }
            self.cityLabel.text = userCity  //set city label
            
            //capture the state
            guard let userState = userData["state"] as! String? else{
                print("No state info found for the user")
                return
            }
            self.stateLabel.text = userState    //set state label
            
            //capture the salary (which becomes GROSS income)
            guard let userGrossIncome = (userData["salary"] as? NSString)?.doubleValue else{
                print("No salary info found for the user")
                return
            }
            self.grossIncomeLabel.text = String(format:"%.2f", userGrossIncome)    //set income label, truncate double
            // initially set userRemains to gross income, it will be decremented later
            var userRemains = userGrossIncome
           
            //capture student loans
            guard let userStudentLoans = (userData["studentLoans"] as? NSString)?.doubleValue else{
                print("No student loan info found for the user")
                return
            }
            
            //capture credit card bill
            guard let userCCBill = (userData["ccbill"] as? NSString)?.doubleValue else{
                print("No credit card info found for the user")
                return
            }
            
            //capture rent
            guard let userRent = (userData["rent"] as? NSString)?.doubleValue else{
                print("No rent info found for the user")
                return
            }
            
            //capture utilities
            guard let userUtilites = (userData["utilities"] as? NSString)?.doubleValue else{
                print("No utility info found for the user")
                return
            }
            
            //get tax rate based on state
            let userTaxRate = self.stateAbbreviations[userState]
            let userTaxValue = userGrossIncome * userTaxRate!
            
            //calculate net income (gross income - taxes)
            let userNetIncome = userGrossIncome - userTaxValue
            self.netIncomeLabel.text = String(format:"%.2f",userNetIncome)    //set net income label
            
            
            self.taxPercentLabel.text = String (userTaxRate! * 100)     //set tax rate label
            self.taxDollarLabel.text = String (format: "%.2f", userTaxRate! * userGrossIncome)     //set tax amount label
            
            self.taxDataEntry.value = userTaxRate! * 100    //set tax value in the chart
            self.taxDataEntry.label = "Taxes"
            self.PieChart.description;"Finances"
            
            //calculate expenses aka rent + utilities
            let userExpenses = userRent + userUtilites
            
            self.rentPercentLabel.text = String(format: "%.2f", userExpenses/userGrossIncome * 100)     //set expenses percent label
            self.rentDollarLabel.text = String(format: "%.2f", userExpenses)    //set expenses amount label
            
            self.rentDataEntry.value = userExpenses/userGrossIncome * 100   //set expenses value in the chart
            self.rentDataEntry.label = "Rent"
            
            
            //calculate total loans aka student loans + credit card bill
            let userLoans = userStudentLoans + userCCBill
            
            self.loanPercentLabel.text = String(format: "%.2f", userLoans/userGrossIncome * 100)    //set loans percent label
            self.loanDollarLabels.text = String(format: "%.2f", userLoans)      //set loans amount label
            
            self.loanDataEntry.value = userLoans/userGrossIncome * 100      //set loans value in the chart
            self.loanDataEntry.label = "Loans"
            
            //calculate remaining money
            userRemains -= (userTaxValue + userExpenses + userLoans)
            
            self.personalPercentLabel.text = String(format: "%.2f", userNetIncome/userGrossIncome * 100)    //set remaining money percent label
            self.personalDollarLabel.text = String(format: "%.2f", userRemains)     //set remaining money amount label
            
            self.personalDataEntry.value = userRemains/userGrossIncome * 100  //set remaining money value in the chart
            self.personalDataEntry.label = "Remains"
            
            self.numberOfDownloadsDataEntries = [self.taxDataEntry, self.rentDataEntry, self.loanDataEntry, self.personalDataEntry]
            
            self.updateChartData()
            
        })
    
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    
    func updateChartData(){
        
        let chartDataSet = PieChartDataSet(values: numberOfDownloadsDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)

        let colors = [UIColor(named: "Rent"), UIColor(named: "Tax"), UIColor(named: "Loan"), UIColor(named: "Color")]

        chartDataSet.colors = colors as! [NSUIColor]
        PieChart.data = chartData
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "editInfoSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       
        if let destination = segue.destination as? ViewControllerTax{
            destination.userEmail = userEmail
        }
        
        if let destination = segue.destination as? RegistrationInfoViewController{
                        destination.userEmail = userEmail
                        destination.cameFromMainScreen = true
                    }
    }
    
    @IBAction func questionMarkPressed(_ sender: Any) {
        let alert = UIAlertController(title: "What's the difference between gross and net income?", message: "Gross income is your total income, and net income is what's left after taxes.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
        }))
        
        self.present(alert, animated:true, completion:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
