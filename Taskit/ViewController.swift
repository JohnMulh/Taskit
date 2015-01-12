//
//  ViewController.swift
//  Taskit
//
//  Created by John Mulholland on 15/12/2014.
//  Copyright (c) 2014 John Mulholland. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var taskArray:[TaskModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an array based on the TaskModel struct to hold items to be shown used in the list.
        
        let date1 = Date.from(year: 2014, month: 05, day: 20)
        let date2 = Date.from(year: 2014, month: 03, day: 3)
        let date3 = Date.from(year: 2014, month: 12, day: 13)
        let date4 = Date.from(year: 2015, month: 01, day: 03)
        
        let task1 = TaskModel(task: "Learn French", subTask: "Verbs", date: date1)
        let task2 = TaskModel(task: "Eat dinner", subTask: "Burgers", date: date2)
        
        // Create taskArray using tasks 1 & 2 constants and then add in two additional tasks
        // using the 'in-line' approach
        
        taskArray = [task1, task2, TaskModel(task: "Gym", subTask: "Leg Day", date: date3), TaskModel(task: "Write Program", subTask: "SubRoutines", date: date4)]
        
        // ensure tableView is refreshed every time viewDidLoad is called
        
        self.tableView.reloadData()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* The function below is called whenever the user taps an item it the tableView and the segue showTaskDetail is called.
    It is used to ensure that the receiving screen i.e. Detail is populated by the information
    held in the tapped item.  Tis information is passed over by the instance of the detailTaskModel in the TaskDetailViewController */
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTaskDetail" {
            let detailVC: TaskDetailViewController = segue.destinationViewController as TaskDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            let thisTask = taskArray[indexPath!.row]
            detailVC.detailTaskModel = thisTask
            detailVC.mainVC = self
        }
        else if segue.identifier == "showTaskAdd" {
           let addTaskVC:addTaskViewController = segue.destinationViewController as addTaskViewController
            addTaskVC.mainVC = self
        }
    }
    
    /* This next function is called when the user taps the add task button on the nav bar of the Tasks screen */
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showTaskAdd", sender: self)
    }
    
    
    // The following two functions are required by the UITableViewDataSource protocol that was added into the ViewController class
    // The first function indicates the number of rows in the tableView that needs to be handled
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    // This second function is used when the user scrolls the tableView.  It indicates identifies the item in the taskArray that needs to be retrieved.  This item is then used to update the various labels fields in an instance of TaskCell and return the information so that it can be displayed using a tableView entry that is no longer needed because it has moved off the screen
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let thisTask = taskArray[indexPath.row]
        var cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell") as TaskCell
        cell.taskLabel.text = thisTask.task
        cell.dateLabel.text = Date.toString(date: thisTask.date)
        cell.descriptionLabel.text = thisTask.subTask
        return cell
    }
    
    // This next function is required by the UITableViewDelegate protocol.  It is called whenever the user taps a table entry activate the segue showTaskDetail.  Note the prepareForSegue function above which is used to populate the target view
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        performSegueWithIdentifier("showTaskDetail", sender: self)
        
    }
}

