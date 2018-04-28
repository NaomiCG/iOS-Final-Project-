//
//  ViewController.swift
//  cache_app
//
//  Created by Naomi Catherine Gheorghe on 4/28/18.
//  Copyright © 2018 ncgheorghe. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    }


    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }


    @IBOutlet weak var first: UITextField!
    
    @IBOutlet weak var last: UITextField!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var birthday: UILabel!
}
