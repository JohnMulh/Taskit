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
    
    It also sets up an instance of the struct TaskModel which is used as a conduit during the segue showTaskDetail to make the information in the tapped cell in the Tasks screen available to the Detail  view.
    */
    
    var detailTaskModel: TaskModel!
    var mainVC:ViewController!
    
    @IBOutlet weak var taskTextField: UILabel!
    @IBOutlet weak var subTaskTextField: UILabel!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.taskTextField.text = detailTaskModel.task
        self.subTaskTextField.text = detailTaskModel.subTask
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
    
    @IBAction func doneBarButtonItemPressed(sender: UIBarButtonItem) {
        var task = TaskModel(task: taskTextField.text!, subTask:subTaskTextField.text!, date: dueDatePicker.date)
        mainVC.taskArray[mainVC.tableView.indexPathForSelectedRow()!.row] = task
        self.navigationController?.popViewControllerAnimated(true)
    }
    

}