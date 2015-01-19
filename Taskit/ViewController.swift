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
   
    // IBOutlet connects to main scrolling table in Storyboard i.e. tableView
    @IBOutlet weak var tableView: UITableView!
    
    // set up instance of managedObjectContext for CoreData use
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    
    // set up variable containg instance of NSFetchedResultsController
    var fetchedResultsController:NSFetchedResultsController = NSFetchedResultsController()
    
//    var taskArray:[TaskModel] = []
//    var baseArray:[[TaskModel]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // next line is in one sense redundant as the same occurs in the getFetchedResultsController function that is being called i.e. getFetchedResultsContoller on its one would suffice.  It updates the fetchedResultsContoller with a CoreData item
        
        fetchedResultsController = getFetchedResultsController()
        // TO BE ADDED
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
    
    /* The function below is called for all the segues.  In the first case - whenever the user taps an item in the tableView and the segue showTaskDetail is called.  It is used to ensure that the receiving screen i.e. Detail is populated by the information held in the tapped item.  This information is passed over by the instance of the detailTaskModel in the TaskDetailViewController.
    
    In the second case if the user taps on the Add button on the tableView there wil be a segue (showAddTask) to the Add new task screen and a copy of the main view controller will be passed to the addTaskViewController so that it can have append a row to the taskArray.  */
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTaskDetail" {
            // set up detailVC constant as an instance of TaskDetailViewController so that information can
            // be passed to it for processing
            let detailVC: TaskDetailViewController = segue.destinationViewController as TaskDetailViewController
            // get the row number that has been tapped in tableView
            let indexPath = self.tableView.indexPathForSelectedRow()
            // create thisTask - a constant populated by the info retrieved by the fetchedResultsController 
            //
            let thisTask = fetchedResultsController.objectAtIndexPath(indexPath!) as TaskModel
            // updates the detailTaskModel variable in the TaskDetailViewController with the contents of thisTask
            detailVC.detailTaskModel = thisTask
        }
        else if segue.identifier == "showTaskAdd" {
            // set up addTaskVC constant as an instance of addTaskViewController
            
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
        // create thisTask - a constant populated by the info retrieved by the fetchedResultsController
        //
        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
        // create a variable called 'cell' as an instance of TaskCell which is defined on the storyboard
        var cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell") as TaskCell
        // update the cell's fields with the data contained in thisTask
        cell.taskLabel.text = thisTask.task
        cell.dateLabel.text = Date.toString(date: thisTask.date)
        cell.descriptionLabel.text = thisTask.subtask
        // return updated cell to the calling function
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
    
    // This function identifies the section and inserts an appropriate header title.
    // Note that the number of section is defined by the SectionNameKeyPath in the getFetchedResultsController
    
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
        
        // First the FetchedResultsController is used to set up a TaskModel constant containing the row that has been swiped on
        
        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
        
     // this part of the function changes the completed status of an item in the To Do (section 0) section
        
        if indexPath.section == 0 {
       thisTask.completed = true
        }
     // this part of the function changes the completed status of an item in the Completed (section 1) section
            
        else {
        thisTask.completed = false

        }
        
    // the function saveContext() is then called to save the changes
        
        (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
    }
    
    // Helper functions
    
    // this function setup a fetchRequest contstant that is used to obtain an instance of the TaskModel
    // so that sort descriptors can be added.
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "TaskModel")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let completedDescriptor = NSSortDescriptor(key: "completed", ascending: true)
        fetchRequest.sortDescriptors = [completedDescriptor, sortDescriptor]
        return fetchRequest
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        // update the fetchedResultsController with information using the taskFetchRequest function as the first parameter and store the results in managedObjectContext.  In addition use the field "completed" to identify the sections in the content.
        fetchedResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: "completed", cacheName: nil)
        return fetchedResultsController
    }
    
    // NSFetchedResultsControllerDelegate
    // This function is called when the NSFetchedResults controller detects changes made in the CoreData stack. Each time it detects changes, we want to reload the information in the tableView
    
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    
    }
}

