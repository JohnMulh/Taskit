//
//  addTaskViewController.swift
//  Taskit
//
//  Created by John Mulholland on 07/01/2015.
//  Copyright (c) 2015 John Mulholland. All rights reserved.
//

import UIKit
import CoreData

class addTaskViewController: UIViewController {

    /*  This class is used to handle the adding of tasks via the add tasks screen */
    
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subtaskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    // This next function is called when the cancel button on the add tasks screen is tapped.  The segue to the was showTaskAdd which was a modal so the cancel button effectively dismisses itself rather than need in to call on the navigationController to do it

    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
    @IBAction func addTaskButtonTapped(sender: UIButton) {

        // This function is called when the "Add task" button is pressed on the Add Task screen.  That data inserted in the fields on that screen by the user are written into a TaskModel variable and this is used to update the CoreData entity.
        
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let managedObjectContext = appDelegate.managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: managedObjectContext!)
        
        let task = TaskModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        task.task = taskTextField.text
        task.subtask = subtaskTextField.text
        task.date = dueDatePicker.date
        task.completed = false
        
        appDelegate.saveContext()
        
        var request = NSFetchRequest(entityName: "TaskModel")
        var error:NSError? = nil
        
        var results:NSArray = managedObjectContext!.executeFetchRequest(request, error: &error)!
        
        for res in results {
            println(res)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
