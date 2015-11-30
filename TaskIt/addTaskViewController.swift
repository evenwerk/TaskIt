//
//  addTaskViewController.swift
//  TaskIt
//
//  Created by Tim Even on 12-03-15.
//  Copyright (c) 2015 evenwerk. All rights reserved.
//

import UIKit
import CoreData

protocol AddTaskViewContollerDelegate {
    func addTask(message:String)
    func addTaskCanceled(message:String)
}

class addTaskViewController: UIViewController {

    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subTaskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    var delegate:AddTaskViewContollerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelButtonTabbed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.addTaskCanceled("Task canceled")
    }
    
    @IBAction func addTaskButtonTapped(sender: UIButton) {
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let managedObjectContext = ModelManager.instance.managedObjectContext!
        let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: managedObjectContext)
        let task = TaskModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCapitalizeTaskKey) == true {
            task.task = taskTextField.text!.capitalizedString
        }
        else {
            task.task = taskTextField.text!
        }
        
        
        task.subtask = subTaskTextField.text!
        task.date = dueDatePicker.date
        
        if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCompleteNewToDoKey) == true {
            task.completed = true
        }
        else {
            task.completed = false
        }
        
        ModelManager.instance.saveContext()
        
        let request = NSFetchRequest(entityName: "TaskModel")
        var error:NSError? = nil
        
        let results:NSArray = try! managedObjectContext.executeFetchRequest(request)
        
        for res in results {
            print(res)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.addTask("Task added!")
    }
}