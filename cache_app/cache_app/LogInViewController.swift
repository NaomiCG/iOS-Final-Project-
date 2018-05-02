//
//  LogInViewController.swift
//  cache_app
//
//  Created by Kelly Williams on 4/29/18.
//  Copyright © 2018 ncgheorghe. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var warning: UILabel!
    
    @IBAction func logIn(_ sender: Any) {
        print("Entered the function")
        if email.text != "" && password.text != ""
        {
            print("Entered the if statement")
            //log in not catching error when people don't have an account
            Auth.auth().signIn(withEmail: (email?.text!)!, password: (password?.text!)!, completion: { (user, error) in
                if user != nil
                {
                    //log in successful
                    print("LOGIN SUCCESSFUL")
                }
                else
                {
                    if let myError = error?.localizedDescription
                    {
                        //we have a description of the error
                        print(myError)
                        self.warning.text = myError
                    }
                    else
                    {
                        print("ERROR")
                        self.warning.text = "Error. Please re-enter values."
                    }
                }
            })
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
