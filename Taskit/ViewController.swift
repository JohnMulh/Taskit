//
//  ViewController.swift
//  Taskit
//
//  Created by John Mulholland on 15/12/2014.
//  Copyright (c) 2014 John Mulholland. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    var fetchedResultsController:NSFetchedResultsController = NSFetchedResultsController()
    
//    var taskArray:[TaskModel] = []
    var baseArray:[[TaskModel]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // nect line is in one sense redundant as the same occurs in the getFetchedResultsController function that is being called i.e. getFetchedResultsContoller on its one would suffice
        
        fetchedResultsController = getFetchedResultsController()
        fetchedResultsController.delegate = self
        fetchedResultsController.performFetch(nil)
        
        
    }
    
    // this function is no longer used because the controllerDidChangeContent is now updating the tableView every time there is a change in the data
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
            let thisTask = fetchedResultsController.objectAtIndexPath(indexPath!) as TaskModel
            detailVC.detailTaskModel = thisTask
        }
        else if segue.identifier == "showTaskAdd" {
           let addTaskVC:addTaskViewController = segue.destinationViewController as addTaskViewController
 
        }
    }
    
    /* This next function is called when the user taps the add task button on the nav bar of the Tasks screen.  It causes a segue to the addTaskViewController so that a new task can be added */
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showTaskAdd", sender: self)
    }
    
    
    // The following three functions are required by the UITableViewDataSource protocol that was added into the ViewController class
    
    // The first function indicates the number of sections in the tableView that needs to be handled

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
   // The second function indicates the number of rows in a section of the tableView that needs to be handled
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    // This third function is used when the user scrolls the tableView.  It indicates identifies the item in  that needs to be retrieved by its section and row.  This item is then used to update the various labels fields in an instance of TaskCell and return the information so that it can be displayed by reusing a tableView entry that is no longer needed because it has scrolled off the screen
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
        var cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell") as TaskCell
        cell.taskLabel.text = thisTask.task
        cell.dateLabel.text = Date.toString(date: thisTask.date)
        cell.descriptionLabel.text = thisTask.subtask
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
        
        // First the FetchedResultsController is used to access the TaskModel instance
        
        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
        
     // this part of the function changes the completed status of an item in the To Do (section 0) section and adds the changed item to the baseArray
        
        if indexPath.section == 0 {
       thisTask.completed = true
        }
     // this part of the function changes the completed status of an item in the Completed (section 1) section and adds the changed item to the baseArray
            
        else {
        thisTask.completed = false

        }
        
    // the function saveContext() is then called to save the changes
        
        (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
    }
    
    // Helper functions
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "TaskModel")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let completedDescriptor = NSSortDescriptor(key: "completed", ascending: true)
        fetchRequest.sortDescriptors = [completedDescriptor, sortDescriptor]
        return fetchRequest
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: "completed", cacheName: nil)
        return fetchedResultsController
    }
    
    // NSFetchedResultsControllerDelegate
    // This function is called when the NSFetchedResults controller detects changes made in the CoreData stack. Each time it detects changes, we want to reload the information in the tableView
    
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    
    }
}

