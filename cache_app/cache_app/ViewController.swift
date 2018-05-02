//
//  ViewController.swift
//  cache_app
//
//  Created by Naomi Catherine Gheorghe on 4/28/18.
//  Copyright © 2018 ncgheorghe. All rights reserved.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController {

    override func viewDidLoad() {
    super.viewDidLoad()
    birthday.setValue(UIColor.white, forKey: "textColor")
    }


    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }

    @IBAction func action(_ sender: Any) {
        if email.text != "" && password.text != ""
        {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                if user != nil
                {
                    //sign up successful
                    print("SIGN UP SUCCESSFUL")
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
    
    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var last: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var birthday: UIDatePicker!

    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var warning: UILabel!
    
}
