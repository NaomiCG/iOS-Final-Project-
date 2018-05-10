//
//  RegistrationInfoViewController.swift
//  cache_app
//
//  Created by Kelly Williams on 5/2/18.
//  Copyright © 2018 ncgheorghe. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RegistrationInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var birthday: UILabel!
    
    @IBOutlet weak var imagePicked: UIImageView!
    
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var stateTextBox: UITextField!
    @IBOutlet weak var stateDropDown: UIPickerView!
    var stateList = ["AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","MD","MA","MI","MN","MS","MO","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
    
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
    

    @IBOutlet weak var removeStudentLoanButton: UIButton!
    @IBOutlet weak var removeCCBillButton: UIButton!
    

    @IBOutlet weak var removeRentButton: UIButton!
    @IBOutlet weak var removeUtilitiesButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    
    //variable to recieve email info from previous view controller
    var userEmail:String?
    
    //boolean to check if what view controller the user is coming from
    var cameFromMainScreen:Bool = false
    
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
            })
            
            dbHandle = dbReference?.child("users").child(userEmail!).child("lastName").observe(.value, with: { (snapshot) in
                let userLastName:String? = snapshot.value as? String
                let userFullName:String = userFirstName! + " " + userLastName!
                self.name.text = userFullName
            })


            dbHandle = dbReference?.child("users").child(userEmail!).child("birthday").observe(.value, with: { (snapshot) in
                let userBirthday:String? = snapshot.value as? String
                self.birthday.text = userBirthday
            })
           
        }
        
        if (cameFromMainScreen){
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
                self.location.text = userCity  //set city label
                
                //capture the state
                guard let userState = userData["state"] as! String? else{
                    print("No state info found for the user")
                    return
                }
                self.stateTextBox.text = userState    //set state label
                
                //capture the employer
                guard let userEmployer = userData["employer"] as! String? else{
                    print("No employer info found for the user")
                    return
                }
                self.companyName.text = userEmployer    //set state label
                
                //capture the salary (which becomes GROSS income)
                guard let userGrossIncome = (userData["salary"] as? NSString)?.doubleValue else{
                    print("No salary info found for the user")
                    return
                }
                self.salary.text = String(format:"%.2f", userGrossIncome)    //set income label, truncate double
                self.salarySlider.setValue(Float(userGrossIncome), animated: false)
                
                //capture student loans
                guard let userStudentLoans = (userData["studentLoans"] as? NSString)?.doubleValue else{
                    print("No student loan info found for the user")
                    return
                }
                self.loanValue.text = String(format:"%.2f", userStudentLoans)
                
                //capture credit card bill
                guard let userCCBill = (userData["ccbill"] as? NSString)?.doubleValue else{
                    print("No credit card info found for the user")
                    return
                }
                self.ccbillValue.text = String(format:"%.2f", userCCBill)
                
                //capture rent
                guard let userRent = (userData["rent"] as? NSString)?.doubleValue else{
                    print("No rent info found for the user")
                    return
                }
                self.rentValue.text = String(format:"%.2f", userRent)
                
                //capture utilities
                guard let userUtilites = (userData["utilities"] as? NSString)?.doubleValue else{
                    print("No utility info found for the user")
                    return
                }
                self.utilitiesValue.text = String(format:"%.2f", userUtilites)
                
            })
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //code to bring up camera
    //not working -- only because of computer??
    @IBAction func openCameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    
    //Slider determines monthly salary
    @IBAction func sliderChanged(_ sender: UISlider) {
        let currentValue:Int = Int(sender.value)
        salary.text = "$ \(currentValue)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let correctEmail = self.email.text!.replacingOccurrences(of: ".", with: ",")
        if let destination = segue.destination as? MainScreenViewController{
            destination.userEmail = correctEmail
        }
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return stateList.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
//        self.view.endEditing(true)
        return stateList[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.stateTextBox.text = self.stateList[row]
        self.stateDropDown.isHidden = true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == stateTextBox {
            self.stateDropDown.isHidden = false
        }
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        dbReference = Database.database().reference()
        let userRef = self.dbReference?.child("users").child(userEmail!)
        userRef?.child("employer").setValue(companyName.text)
        userRef?.child("city").setValue(location.text)
        userRef?.child("state").setValue(stateTextBox.text)
        var salaryFormatted = salary.text?.replacingOccurrences(of: "$ ", with: "", options: NSString.CompareOptions.literal, range: nil)
        userRef?.child("salary").setValue(salaryFormatted)
        userRef?.child("studentLoans").setValue(loanValue.text)
        userRef?.child("ccbill").setValue(ccbillValue.text)
        userRef?.child("rent").setValue(rentValue.text)
        userRef?.child("utilities").setValue(utilitiesValue.text)
        
        self.performSegue(withIdentifier: "InfoToMainScreen", sender: self)
        
    }
    
    
    
    
    
    //the following functions are to remove fields that aren't relevant to a user
    @IBAction func removeCCBill(_ sender: Any) {
        ccbillLabel.isHidden = true
        ccbillValue.isHidden = true
        removeCCBillButton.isHidden = true
//        loansCount -= 1
    }
    
    @IBAction func removeStudentLoan(_ sender: Any) {
        loanLabel.isHidden = true
        loanValue.isHidden = true
        removeStudentLoanButton.isHidden = true
//        loansCount -= 1
    }
    
    @IBAction func removeRent(_ sender: Any) {
        rentLabel.isHidden = true
        rentValue.isHidden = true
        removeRentButton.isHidden = true
//        expensesCount -= 1
    }
    
    @IBAction func removeUtilities(_ sender: Any) {
        utilitiesLabel.isHidden = true
        utilitiesValue.isHidden = true
        removeUtilitiesButton.isHidden = true
//        expensesCount -= 1
    }
    @IBAction func loanButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "What's a loan?", message: "the lending of money from one individual, organization or entity to another individual, organization or entity.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
        }))
        
        self.present(alert, animated:true, completion:nil)
        
    }
    
    //for when the user wants to add an additional living expense, ie wifi or cell phone bill etc
    @IBAction func addLivingExpense(_ sender: Any) {
        let alert = UIAlertController(title: "What's included in living expenses?", message: "rent, utilities (water, gas, electricity, wifi), phone bill, etc.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
        }))
        
        self.present(alert, animated:true, completion:nil)
        
        
    }
    
//    func createExpenseBoxes(alert: UIAlertController) {
//        let yValue = 600 + expensesCount*46
//        let label = UILabel(frame:CGRect(x:16, y:yValue, width:108, height:21))
//        label.text = alert.textFields?[0].text
//        label.font = UIFont(name:"HelveticaNeue-Thin", size:label.font.pointSize)
//        self.view.addSubview(label)
//    }
    
}
