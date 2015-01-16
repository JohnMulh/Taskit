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
    
//    var taskArray:[TaskModel] = []
    var baseArray:[[TaskModel]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Create an array based on the TaskModel struct to hold items to be shown used in the list.
        
        let date1 = Date.from(year: 2014, month: 05, day: 20)
        let date2 = Date.from(year: 2014, month: 03, day: 3)
        let date3 = Date.from(year: 2014, month: 12, day: 13)
        let date4 = Date.from(year: 2015, month: 01, day: 03)
        
        let task1 = TaskModel(task: "Learn French", subTask: "Verbs", date: date1, completed: false)
        let task2 = TaskModel(task: "Eat dinner", subTask: "Burgers", date: date2, completed: false)
        
        // Create taskArray using tasks 1 & 2 constants and then add in two additional tasks
        // using the 'in-line' approach
        
        let taskArray = [task1, task2, TaskModel(task: "Gym", subTask: "Leg Day", date: date3, completed: false), TaskModel(task: "Write Program", subTask: "SubRoutines", date: date4, completed: false)]

        
        var completedArray = [TaskModel(task: "Code", subTask: "Task Project", date: date2, completed: true)]
        baseArray = [taskArray, completedArray]
        
     
        
        
        // ensure tableView is refreshed every time viewDidLoad is called
        
        self.tableView.reloadData()
        
    }
    
    // this function is called everytime tableView is displayed.  It sorts the taskArray before reloading all the data.
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        baseArray[0] = baseArray[0].sorted {
        (taskOne:TaskModel, taskTwo:TaskModel) -> Bool in
                return taskOne.date.timeIntervalSince1970 < taskTwo.date.timeIntervalSince1970
        }
        
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* The function below is called whenever the user taps an item it the tableView and the segue showTaskDetail is called.
    It is used to ensure that the receiving screen i.e. Detail is populated by the information
    held in the tapped item.  This information is passed over by the instance of the detailTaskModel in the TaskDetailViewController at the same time an instance of the main viewcontroller is passed to the TaskDetailViewController so that it has access to the taskArray enabling the user to make changes.
    
    In addition if the user taps on the Add button on the tableView there wil be a segue (showAddTask) to the Add new task screen and a copy of the main view controller will be passed to the addTaskViewController so that it can have append a row to the taskArray.  */
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTaskDetail" {
            let detailVC: TaskDetailViewController = segue.destinationViewController as TaskDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            let thisTask = baseArray[indexPath!.section][indexPath!.row]
            detailVC.detailTaskModel = thisTask
            detailVC.mainVC = self
        }
        else if segue.identifier == "showTaskAdd" {
           let addTaskVC:addTaskViewController = segue.destinationViewController as addTaskViewController
            addTaskVC.mainVC = self
        }
    }
    
    /* This next function is called when the user taps the add task button on the nav bar of the Tasks screen.  It causes a segue to the addTaskViewController so that a new task can be added */
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showTaskAdd", sender: self)
    }
    
    
    // The following three functions are required by the UITableViewDataSource protocol that was added into the ViewController class
    
    // The first function indicates the number of sections in the tableView that needs to be handled

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return baseArray.count
    }
   // The second function indicates the number of rows in a section of the tableView that needs to be handled
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return baseArray[section].count
    }
    // This third function is used when the user scrolls the tableView.  It indicates identifies the item in the baseArray that needs to be retrieved by its section and row.  This item is then used to update the various labels fields in an instance of TaskCell and return the information so that it can be displayed by reusing a tableView entry that is no longer needed because it has scrolled off the screen
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let thisTask = baseArray[indexPath.section][indexPath.row]
        var cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell") as TaskCell
        cell.taskLabel.text = thisTask.task
        cell.dateLabel.text = Date.toString(date: thisTask.date)
        cell.descriptionLabel.text = thisTask.subTask
        return cell
    }
    
    // The following functions are required by the UITableViewDelegate protocol.  
    
    // This next function is called whenever the user taps a table entry to activate the segue showTaskDetail.  Note the prepareForSegue function above which is used to populate the target view
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        performSegueWithIdentifier("showTaskDetail", sender: self)
        
    }
    
    // This function sets up a header entry height for each section of the tableView
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    // This function identifies the section and inserts an appropriate header title
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "To Do"
        }
        else {
            return "Completed"
        }
    }
    
    // This function is used to allow the user to swipe across the item in the tableView. When the user taps the resulting Delete the task will be deleted from the relevant section and added to the other one.
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let thisTask = baseArray[indexPath.section][indexPath.row]
     // this part of the function changes the completed status of an item in the To Do (section 0) section and adds the changed item to the baseArray
        if indexPath.section == 0 {
        var newTask = TaskModel(task: thisTask.task, subTask: thisTask.subTask, date: thisTask.date, completed: true)
            baseArray[1].append(newTask)
        }
     // this part of the function changes the completed status of an item in the Completed (section 1) section and adds the changed item to the baseArray
        else {
        var newTask = TaskModel(task: thisTask.task, subTask: thisTask.subTask, date: thisTask.date, completed: false)
            baseArray[0].append(newTask)

        }
        
    // this part of the function removes the item that has been selected from the baseArray and then reloads the tableView
        
        baseArray[indexPath.section].removeAtIndex(indexPath.row)
        tableView.reloadData()
    }
}

