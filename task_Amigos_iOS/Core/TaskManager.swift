//
//  TaskManager.swift
//  task_Amigos_iOS
//
//  Created by Daniel Miolan on 1/20/22.
//

import UIKit
import Foundation
import CoreData

class TaskManager {
    var tasks: [Task]
    var incompleteTasks: [Task] = [Task]()
    var completeTasks: [Task] = [Task]()
    var managedContext: NSManagedObjectContext!
    
    init() {
        tasks = [Task]()
        incompleteTasks = [Task]()
        completeTasks = [Task]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        //clearTaskData()
        loadData()
    }
    
    func loadData() {
        tasks = [Task]()
        incompleteTasks = [Task]()
        completeTasks = [Task]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if results is [NSManagedObject] {
            for result in (results as! [NSManagedObject]) {
                let name = result.value(forKey: "name") as! String
                let descr = result.value(forKey: "desc") as! String
                let status = result.value(forKey: "status") as! Status.RawValue
                let subtask = result.value(forKey: "subtask") as! [Int]
                let images = result.value(forKey: "images") as! [String]
                let audios = result.value(forKey: "audios") as! [String]
                let dueDate = result.value(forKey: "dueDate") as! Date
                let createdDate = result.value(forKey: "createdDate") as! Date
                let cat = result.value(forKey: "category") as! Category.RawValue
                let tempTask = Task(id: 0, name: name, description: descr, category: Category(rawValue: cat)!, status: Status(rawValue: status)!, subTask: subtask, images: images, audios: audios, dueDate: dueDate, createdDate: createdDate)
                
                    tasks.append(tempTask)
                    if(Status(rawValue: status)! == Status.incomplete){
                        incompleteTasks.append(tempTask)
                    }else{
                        completeTasks.append(tempTask)
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    //function to add a task to core data
    func addTask(task:Task, view: UIViewController){
            let newTask = NSEntityDescription.insertNewObject(forEntityName: "TaskEntity", into: managedContext)
            
            newTask.setValue(task.getName(), forKey: "name")
            newTask.setValue(task.getDescription(), forKey: "desc")
            newTask.setValue(task.getStatus().rawValue, forKey: "status")
            newTask.setValue(task.getSubTask(), forKey: "subtask")
            newTask.setValue(task.getImages(), forKey: "images")
            newTask.setValue(task.getAudios(), forKey: "audios")
            newTask.setValue(task.getDueDate(), forKey: "dueDate")
            newTask.setValue(task.getCreatedDate(), forKey: "createdDate")
            newTask.setValue(task.getCategory().rawValue, forKey: "category")

            do {
                try managedContext.save()
                print("Record Added!")
                //To display an alert box
                let alertController = UIAlertController(title: "Message", message: "Task Added!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) {
                    (action: UIAlertAction!) in
                }
                alertController.addAction(OKAction)
                view.present(alertController, animated: true, completion: nil)
            } catch let error as NSError {
                print("Could not save. \(error),\(error.userInfo)")
            }
    }
    
    // function to delete all tasks from core data
    func clearTaskData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")

        do {
            let results = try managedContext.fetch(fetchRequest)
            for result in results {
                if let managedObject = result as? NSManagedObject {
                    managedContext.delete(managedObject)
                }
            }
            
            try managedContext.save()
        } catch {
            print("Error deleting records \(error)")
        }
    }
    
    func getIncompleteTasksList() -> [Task] {
        return incompleteTasks
    }
    
    func getCompleteTasksList() -> [Task] {
        return completeTasks
    }
    
    func getTaskByIndex(index: Int) -> Task {
        return tasks[index]
    }
}
