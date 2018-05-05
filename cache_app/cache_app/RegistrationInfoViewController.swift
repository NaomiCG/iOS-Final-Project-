//
//  RegistrationInfoViewController.swift
//  cache_app
//
//  Created by Kelly Williams on 5/2/18.
//  Copyright © 2018 ncgheorghe. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RegistrationInfoViewController: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var birthday: UILabel!
    
    
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var salary: UILabel!
    @IBOutlet weak var salarySlider: UISlider!
    
    @IBOutlet weak var loanLabel: UILabel!
    @IBOutlet weak var loanValue: UITextField!
    @IBOutlet weak var ccbillLabel: UILabel!
    @IBOutlet weak var ccbillValue: UITextField!
    
    @IBOutlet weak var rentLabel: UILabel!
    @IBOutlet weak var rentValue: UITextField!
    @IBOutlet weak var utilitiesLabel: UILabel!
    @IBOutlet weak var utilitiesValue: UITextField!
    
    @IBOutlet weak var newLoanButton: UIButton!
    @IBOutlet weak var removeStudentLoanButton: UIButton!
    @IBOutlet weak var removeCCBillButton: UIButton!
    
    @IBOutlet weak var newLivingExpenseButton: UIButton!
    @IBOutlet weak var removeRentButton: UIButton!
    @IBOutlet weak var removeUtilitiesButton: UIButton!
    
    //variable to recieve email info from previous view controller
    var userEmail:String?
    
    //keep track of how many different fields the user has filled out/is relevant to the user
    //necessary for math later when we are adding new fields
    var loansCount:Int = 2
    var expensesCount:Int = 2
    
    var dbReference : DatabaseReference?
    var dbHandle : DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbReference = Database.database().reference()
        
        //setting up user info that we already have
        //aka displaying their name, email, and birthday
        
        if userEmail != nil{
            email.text = userEmail
            
            var userFirstName:String? = ""
            dbHandle = dbReference?.child("users").child(userEmail!).child("firstName").observe(.value, with: { (snapshot) in
                userFirstName = snapshot.value as? String
//                print(userFirstName)
            })
            
            dbHandle = dbReference?.child("users").child(userEmail!).child("lastName").observe(.value, with: { (snapshot) in
                let userLastName:String? = snapshot.value as? String
                let userFullName:String = userFirstName! + " " + userLastName!
                self.name.text = userFullName
//                print(userFullName)
            })


            dbHandle = dbReference?.child("users").child(userEmail!).child("birthday").observe(.value, with: { (snapshot) in
                let userBirthday:String? = snapshot.value as? String
                self.birthday.text = userBirthday
//                print(userBirthday)
            })
           
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Slider determines monthly salary
    @IBAction func sliderChanged(_ sender: UISlider) {
        var currentValue = sender.value
        salary.text = "$ \(currentValue)"
    }
    
    //the following functions are to remove fields that aren't relevant to a user
    @IBAction func removeCCBill(_ sender: Any) {
        ccbillLabel.isHidden = true
        ccbillValue.isHidden = true
        removeCCBillButton.isHidden = true
        loansCount -= 1
    }
    
    @IBAction func removeStudentLoan(_ sender: Any) {
        loanLabel.isHidden = true
        loanValue.isHidden = true
        removeStudentLoanButton.isHidden = true
        loansCount -= 1
    }
    
    @IBAction func removeRent(_ sender: Any) {
        rentLabel.isHidden = true
        rentValue.isHidden = true
        removeRentButton.isHidden = true
        expensesCount -= 1
    }
    
    @IBAction func removeUtilities(_ sender: Any) {
        utilitiesLabel.isHidden = true
        utilitiesValue.isHidden = true
        removeUtilitiesButton.isHidden = true
        expensesCount -= 1
    }
    
    //for when the user wants to add an additional living expense, ie wifi or cell phone bill etc
    @IBAction func addLivingExpense(_ sender: Any) {
        let alert = UIAlertController(title: "Additional Living Expense", message: "Enter the type and amount of expense", preferredStyle: .alert)
        alert.addTextField{ (textField) in
            textField.text = "Type of Expense"
        }
        alert.addTextField{ (textField) in
            textField.text = "Monthly Amount"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            let otherTextField = alert?.textFields![1]
            print("Text field: \(textField?.text) & \(otherTextField?.text)")
        }))
        
        self.present(alert, animated:true, completion:nil)
        
        //happening too fast - need to figure out how to wait
        //think i need to move it to another function but haven't figured that out
        
        let yValue = 600 + expensesCount*46
        
        let label = UILabel(frame:CGRect(x:16, y:yValue, width:108, height:21))
        label.text = alert.textFields?[0].text
        label.font = UIFont(name:"HelveticaNeue-Thin", size:label.font.pointSize)
        self.view.addSubview(label)
        
    }
    
//    func createExpenseBoxes(alert: UIAlertController) {
//        let yValue = 600 + expensesCount*46
//        let label = UILabel(frame:CGRect(x:16, y:yValue, width:108, height:21))
//        label.text = alert.textFields?[0].text
//        label.font = UIFont(name:"HelveticaNeue-Thin", size:label.font.pointSize)
//        self.view.addSubview(label)
//    }
    
}
