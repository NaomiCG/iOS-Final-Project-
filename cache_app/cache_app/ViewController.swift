//
//  ViewController.swift
//  cache_app
//
//  Created by Naomi Catherine Gheorghe on 4/28/18.
//  Copyright © 2018 ncgheorghe. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var last: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var birthday: UIDatePicker!
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var warning: UILabel!
    
    var birthdayString : String = ""
    
    var dbReference : DatabaseReference?
    var dbHandle : DatabaseHandle?

    
    override func viewDidLoad() {
    super.viewDidLoad()
    birthday.setValue(UIColor.white, forKey: "textColor")
        
        
        //set data///////////////
        
//        dbReference = Database.database().reference()
//        dbReference?.child("users").child("username").setValue("Yash")
        
        
        //retrieve data//////////
//        dbHandle = dbReference?.child("users").observe(.childAdded, with: { (snapshot) in
//            let name:String? = snapshot.value as? String
//            print(name)
//        })
        
//        dbHandle = dbReference?.child("users").observe(.value, with: { (snapshot) in
//            let name:String? = snapshot.value as? String
//            print(name)
//        })
        
    }


    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }


    @IBAction func datePickerChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM / dd / YYYY"
        birthdayString = dateFormatter.string(from: sender.date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let correctEmail = self.email.text!.replacingOccurrences(of: ".", with: ",")
        if let destination = segue.destination as? RegistrationInfoViewController{
            destination.userEmail = correctEmail
        }
    }
    
    
    @IBAction func action(_ sender: Any) {
        if email.text != "" && password.text != ""
        {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                if user != nil
                {
                    //sign up successful
                    print("SIGN UP SUCCESSFUL")
                    
                    //reformat emails to use , instead of dot (aka kpw243@nyu,edu)
                    //firebase does not allow . in keys
                    let correctEmail = self.email.text!.replacingOccurrences(of: ".", with: ",")
                    
                    //create reference to database
                    self.dbReference = Database.database().reference()
                    
                    //create reference to this user's data (just to shorten the commands)
                    let userRef = self.dbReference?.child("users").child(correctEmail)
                    //add data to database at that user's child node
                    userRef?.child("firstName").setValue(self.first.text!)
                    userRef?.child("lastName").setValue(self.last.text!)
                    userRef?.child("birthday").setValue(self.birthdayString)
                    
                    self.performSegue(withIdentifier: "SegueToRegistrationInfo", sender: self)
                }
                else
                {
                    if let myError = error?.localizedDescription
                    {
                        //we have a description of the error
                        print(myError)
                        self.warning.text = myError;
                        
                    }
                    else
                    {
                        print("ERROR")
                        self.warning.text = "Error, please review fields."
                    }
                }
            })
        }
    }
    
    
    
}
