//
//  TaskDetailViewController.swift
//  Taskit
//
//  Created by John Mulholland on 30/12/2014.
//  Copyright (c) 2014 John Mulholland. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    /* This class is used to work with the storyboard Detail view.
    
    The relevant label and date picker fields are attached to this class via the IBOutlets.
    
    It also sets up an instance of the TaskModel defined in the TaskModel class set up by the Core Data TaskitModel.xcdatamodeld.
    */
    
    var detailTaskModel: TaskModel!
    
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subTaskTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.taskTextField.text = detailTaskModel.task
        self.subTaskTextField.text = detailTaskModel.subtask
        self.dueDatePicker.date = detailTaskModel.date
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The function below is called when the user taps on the cancel button on the Details screen. Because the segue to this screen was via the navigationController it pops the view off the stack thereby returning to the previous screen displayed by the navigationController i.e. the Tasks screen
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // The function below is called when the user taps the "Done" button on the Detail task screen. Any data that has been amended into the fields on the screen is written into the Core Data TaskModel variable  and saved by  appDelegate.saveContext.
    
    @IBAction func doneBarButtonItemPressed(sender: UIBarButtonItem) {
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        detailTaskModel.task = taskTextField.text
        detailTaskModel.subtask = subTaskTextField.text
        detailTaskModel.date = dueDatePicker.date
        appDelegate.saveContext()
        self.navigationController?.popViewControllerAnimated(true)
    }
    

}