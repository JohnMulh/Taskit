//
//  addTaskViewController.swift
//  Taskit
//
//  Created by John Mulholland on 07/01/2015.
//  Copyright (c) 2015 John Mulholland. All rights reserved.
//

import UIKit

class addTaskViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
}
