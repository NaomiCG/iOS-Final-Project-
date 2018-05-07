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

class MainScreenViewController: UIViewController {
    
    
    //pie chart
    @IBOutlet weak var pieChart: PieChartView!
    
    //incomes labels
    @IBOutlet weak var grossIncomeLabel: UILabel!
    var grossIncomeVar:String = ""
    @IBOutlet weak var netIncomeLabel: UILabel!
    var netIncomeVar:Double = 0.0
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbReference = Database.database().reference()
        
        //tax rate
        var taxRate:Double = 0.0
        dbHandle = dbReference?.child("users").child(userEmail!).child("state").observe(.value, with: { (snapshot) in
            if let userState = (snapshot.value as? String){
                taxRate = self.stateAbbreviations[userState]!
                print("tax rate within: \(String(describing: taxRate))")
            }
        })
        
        //state
        var state:String? = ""
        dbHandle = dbReference?.child("users").child(userEmail!).child("state").observe(.value, with: { (snapshot) in
            state = snapshot.value as? String
            self.stateLabel.text = state
            self.stateVar = state!
        })
        
        //city
        var city:String? = ""
        dbHandle = dbReference?.child("users").child(userEmail!).child("city").observe(.value, with: { (snapshot) in
            city = snapshot.value as? String
            self.cityLabel.text = city
            self.cityVar = city!
        })
        
        //gross and net income
        var income:String? = ""
        dbHandle = dbReference?.child("users").child(userEmail!).child("salary").observe(.value, with: { (snapshot) in
            income = snapshot.value as? String
            
            //gross income
            self.grossIncomeLabel.text = income
            self.grossIncomeVar = income!
            
            //net income
            let netIncome = Double(income!)! - (Double (taxRate) * Double(income!)!)
            self.netIncomeLabel.text = String (netIncome)
            
            //tax
            self.taxPercentLabel.text = String ((Double (taxRate) * 100))
            self.taxDollarLabel.text = String (Double (taxRate) * Double(income!)!)
            
        })
        
        /*
         //rent
         var rent:String? = ""
         dbHandle = dbReference?.child("users").child(userEmail!).child("rent").observe(.value, with: { (snapshot) in
         rent = snapshot.value as? String
         self.rentDollarLabel.text = rent
         //self.rentDollarVar = rent
         
         //let rentPercent = Double (rent)! / Double (grossIncomeVar)!
         //self.rentPercentVar.text = String (rentPercent)
         })
         
         //student loans
         var studentLoans:String? = ""
         dbHandle = dbReference?.child("users").child(userEmail!).child("studentLoans").observe(.value, with: { (snapshot) in
         studentLoans = snapshot.value as? String
         self.loanDollarLabels.text = studentLoans
         //self.rentDollarVar = rent
         
         //let rentPercent = Double (rent)! / Double (grossIncomeVar)!
         //self.rentPercentVar.text = String (rentPercent)
         })
         */
        
        self.rentDollarLabel.text = "1650.00"
        self.rentPercentLabel.text = "41.25"
        self.loanDollarLabels.text = "400.00"
        self.loanPercentLabel.text = "10"
        self.personalDollarLabel.text = "630.00"
        self.personalPercentLabel.text = "15.75"
        
        var rentData = PieChartDataEntry(value: 41.25)
        var taxData = PieChartDataEntry(value: 33.00)
        var loanData = PieChartDataEntry(value: 10)
        var remains = PieChartDataEntry(value: 15.75)
        func updateChartData(){
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        /*
         //rent and utilities
         var rent:Double? = 0.0
         dbHandle = dbReference?.child("users").child(userEmail!).child("rent").observe(.value, with: { (snapshot) in
         rent = snapshot.value as? Double
         //self.rentDollarLabel.text = rent
         //rents = rent!
         self.rentDollarVar = rent!
         })
         */
        
        /*
         var utilities:Double? = 0.0
         dbHandle = dbReference?.child("users").child(userEmail!).child("utilities").observe(.value, with: { (snapshot) in
         utilities = snapshot.value as? Double
         
         self.utilitiesDollarVar = utilities!
         
         //var totalRent = utilities! + rent!
         
         self.rentDollarLabel.text = String (self.rentDollarVar + self.utilitiesDollarVar)
         })
         */
        
        /*
         //student loans
         var loanValue:Double? = 0.0
         dbHandle = dbReference?.child("users").child(userEmail!).child("loanValue").observe(.value, with: { (snapshot) in
         loanValue = snapshot.value as? Double
         
         self.loanDollarVar = loanValue!
         })
         */
        
        /*
         var income:String? = ""
         dbHandle = dbReference?.child("users").child(userEmail!).child("salary").observe(.value, with: { (snapshot) in
         income = snapshot.value as? String
         print(taxRate * Double(income!)!)
         
         /////////////////////////////////////////////////////////////
         //incomes labels
         //grossIncomeLabel
         self.grossIncomeLabel.text = income
         //netIncomeLabel
         let netIncome = Double(income!)! - (Double (taxRate) * Double(income!)!)
         self.netIncomeLabel.text = String (netIncome)
         /////////////////////////////////////////////////////////////
         
         /////////////////////////////////////////////////////////////
         //taxes labels
         //taxPercentLabel
         self.taxPercentLabel.text = String ((Double (taxRate) * 100))
         //taxDollarLabel
         self.taxDollarLabel.text = String (Double (taxRate) * Double(income!)!)
         /////////////////////////////////////////////////////////////
         
         })
         */
        
        
        
        
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


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        print("**** \(self.navigationController) ****")
    }
    
}
