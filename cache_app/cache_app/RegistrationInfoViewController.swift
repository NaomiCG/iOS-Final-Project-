//
//  RegistrationInfoViewController.swift
//  cache_app
//
//  Created by Kelly Williams on 5/2/18.
//  Copyright © 2018 ncgheorghe. All rights reserved.
//

import UIKit

class RegistrationInfoViewController: UIViewController {
    @IBOutlet weak var name: UITextField!
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
    
    
    var loansCount:Int = 2
    var expensesCount:Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        var currentValue = sender.value
        salary.text = "$ \(currentValue)"
    }
    
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
        
        var yValue = 600 + expensesCount*46
        
        let label = UILabel(frame:CGRect(x:16, y:yValue, width:108, height:21))
        label.text = alert.textFields?[0].text
        self.view.addSubview(label)
        
        
        
    }
    
}
