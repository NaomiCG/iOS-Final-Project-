//
//  ViewControllerTax.swift
//  cache_app
//
//  Created by Naomi Catherine Gheorghe on 5/11/18.
//  Copyright © 2018 ncgheorghe. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Charts


class ViewControllerTax: UIViewController {

    @IBOutlet weak var pieChart: PieChartView!
    //income labels
    @IBOutlet weak var grossincome: UILabel!
    @IBOutlet weak var netincome: UILabel!
    
    //state and city labels
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var city: UILabel!
    
    //taxes labels

    @IBOutlet weak var fedPercent: UILabel!
    @IBOutlet weak var fedDollar: UILabel!
  
    @IBOutlet weak var statePercent: UILabel!
    @IBOutlet weak var stateDollar: UILabel!

    @IBOutlet weak var cityPercent: UILabel!

    @IBOutlet weak var cityDollar: UILabel!
    
    
    
    //db references
    var dbReference : DatabaseReference?
    var dbHandle : DatabaseHandle?
    
    
    
    //state info
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
    //pie chart info
    var taxDataEntry = PieChartDataEntry()
    var rentDataEntry = PieChartDataEntry()
    var loanDataEntry = PieChartDataEntry()
    var personalDataEntry = PieChartDataEntry()
    
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pie chart description
        dbReference = Database.database().reference()
        
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
            self.city.text = userCity  //set city label
            
            //capture the state
            guard let userState = userData["state"] as! String? else{
                print("No state info found for the user")
                return
            }
            self.state.text = userState    //set state label
  
            //capture the salary (which becomes GROSS income)
            guard let userGrossIncome = (userData["salary"] as? NSString)?.doubleValue else{
                print("No salary info found for the user")
                return
            }
            self.grossincome.text = String(format:"%.2f", userGrossIncome)    //set income label, truncate double
            // initially set userRemains to gross income, it will be decremented later
            var userRemains = userGrossIncome
            //state - tax income
            let userTaxRate = self.stateAbbreviations[userState]
            let userTaxValue = userGrossIncome * userTaxRate!
            
            //calculate net income (gross income - taxes)
            let userNetIncome = userGrossIncome - userTaxValue
            self.netincome.text = String(format:"%.2f",userNetIncome)    //set net income label
            
            
            
            
        //end of dbhandle
            
        }
            
    )}
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MainScreenViewController{
            destination.userEmail = userEmail
//            destination.cameFromMainScreen = true
        }
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
