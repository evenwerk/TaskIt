//
//  ViewController.swift
//  TaskIt
//
//  Created by Tim Even on 04-03-15.
//  Copyright (c) 2015 evenwerk. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, TaskDetailViewControllerDelegate, AddTaskViewContollerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var fetchResultsController:NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        fetchResultsController = getFetchedResultsController()
        fetchResultsController.delegate = self
        do {
            try fetchResultsController.performFetch()
        } catch _ {
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("iCloudUpdated"), name: "coreDataUpdated", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTaskDetail" {
            let detailVC:TaskDetailViewController = segue.destinationViewController as! TaskDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            let thisTask = fetchResultsController.objectAtIndexPath(indexPath!) as! TaskModel
            detailVC.detailTaskModel = thisTask
            detailVC.delegate = self
        }
        else if segue.identifier == "showTaskAdd" {
            let addTaskVC:addTaskViewController = segue.destinationViewController as! addTaskViewController
            addTaskVC.delegate = self
        }
    }
    
    @IBAction func addButtonTabbed(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showTaskAdd", sender: self)
    }
    
    
    //UIViewTableSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchResultsController.sections!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.sections![section].numberOfObjects    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let thisTask = fetchResultsController.objectAtIndexPath(indexPath) as! TaskModel
        
        let cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell") as! TaskCell
        cell.taskLabel.text = thisTask.task
        cell.descriptionLabel.text = thisTask.subtask
        cell.dateLabel.text = Date.toString(date: thisTask.date)
        
        return cell
    }
    
    //UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        performSegueWithIdentifier("showTaskDetail", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if fetchResultsController.sections?.count == 1 {
            let fetchedObjects = fetchResultsController.fetchedObjects!
            let testTask:TaskModel = fetchedObjects[0] as! TaskModel
            if testTask.completed == true {
                return "Completed"
            }
            else {
                return "To do"
            }
        }
        else {
            if section == 0 {
                return "To do"
            }
            else {
                return "Completed"
            }
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let thisTask = fetchResultsController.objectAtIndexPath(indexPath) as! TaskModel
        
        if thisTask.completed == true {
            thisTask.completed = false
        }
        else {
            thisTask.completed = true
        }
        
        ModelManager.instance.saveContext()
    }
    
    
    //NSFetchResultsControllerDelegate
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    //Helper
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "TaskModel")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let completedDescriptor = NSSortDescriptor(key: "completed", ascending: true)
        fetchRequest.sortDescriptors = [completedDescriptor, sortDescriptor]
        
        return fetchRequest
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        fetchResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: ModelManager.instance.managedObjectContext!, sectionNameKeyPath: "completed", cacheName: nil)
        return fetchResultsController
    }
    
    //TaskDetailViewControllerDelegate
    
    func taskDetailEdited() {
        showAlert()
    }
    
    //AddTaskViewControllerDelegate
    
    func addTaskCanceled(message: String) {
        showAlert(message)
    }
    
    func addTask(message: String) {
        showAlert(message)
    }
    
    func showAlert(message: String = "Congradulations") {
        let alert = UIAlertController(title: "Change Made", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //iCloud Notification
    
    func iCloudUpdated() {
        tableView.reloadData()
    }
}

