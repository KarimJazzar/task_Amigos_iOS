//
//  TaskManager.swift
//  task_Amigos_iOS
//
//  Created by Daniel Miolan on 1/20/22.
//

import UIKit
import Foundation
import CoreData

let taskManager: TaskManager = TaskManager()

class TaskManager {
    private var taskList: [Task]
    private var taskEntitiesList: [TaskEntity]
    private var managedContext: NSManagedObjectContext!
    private let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
    
    init() {
        taskList = [Task]()
        taskEntitiesList = [TaskEntity]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        //clearTaskData()
        loadData()
    }
    
    func loadData() {
        taskList = [Task]()
        
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
                    
                    taskList.append(tempTask)
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
                taskList.append(task)
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
    
    func updateTask(task: Task) {
        let id = task.getId()
        let index = taskList.firstIndex(where: { $0.getId() == id }) ?? -1
        
        if index < 0 {
            return
        }
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            if let managedObject = results[index] as? NSManagedObject {
                taskList[index] = task
                
                managedObject.setValue(task.getName(), forKey: "name")
                managedObject.setValue(task.getDescription(), forKey: "desc")
                managedObject.setValue(task.getStatus().rawValue, forKey: "status")
                managedObject.setValue(task.getSubTask(), forKey: "subtask")
                managedObject.setValue(task.getImages(), forKey: "images")
                managedObject.setValue(task.getAudios(), forKey: "audios")
                managedObject.setValue(task.getDueDate(), forKey: "dueDate")
                managedObject.setValue(task.getCreatedDate(), forKey: "createdDate")
                managedObject.setValue(task.getCategory().rawValue, forKey: "category")
                
                try managedContext.save()
            }
        } catch {
            print("Error deleting records \(error)")
        }
    }
    
    func remuveTaskById(id: Int) {
        let index = taskList.firstIndex(where: { $0.getId() == id }) ?? -1
        
        if index < 0 {
            return
        }
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            if let managedObject = results[index] as? NSManagedObject {
                taskList.remove(at: index)
                managedContext.delete(managedObject)
                try managedContext.save()
            }
        } catch {
            print("Error deleting records \(error)")
        }
    }
    
    func getIncompleteTasksList() -> [Task] {
        var incompleteTasks: [Task] = [Task]()
        
        for task in taskList {
            if task.getStatus() == Status.incomplete {
                incompleteTasks.append(task)
            }
        }
        
        return incompleteTasks
    }
    
    func getImcompleteTaskMatches(value: String) -> [Task] {
        var incompleteTasks: [Task] = [Task]()
    
        var isIncomplete = false
        var nameMatch = false
        var descriptionMatch = false
        
        for task in taskList {
            isIncomplete = task.getStatus() == Status.incomplete
            nameMatch =  task.getName().lowercased().contains(value.lowercased())
            descriptionMatch = task.getName().lowercased().contains(value.lowercased())
            
            if isIncomplete && (nameMatch || descriptionMatch) {
                incompleteTasks.append(task)
            }
        }
        
        return incompleteTasks
    }
    
    func getCompleteTasksList() -> [Task] {
        var completeTasks: [Task] = [Task]()
        
        for task in taskList {
            if task.getStatus() == Status.complete {
                completeTasks.append(task)
            }
        }
        
        return completeTasks
    }
    
    func getCompleteTaskMatches(value: String) -> [Task] {
        var completeTasks: [Task] = [Task]()
        
        var isIncomplete = false
        var nameMatch = false
        var descriptionMatch = false
        
        for task in taskList {
            isIncomplete = task.getStatus() == Status.complete
            nameMatch =  task.getName().lowercased().contains(value.lowercased())
            descriptionMatch = task.getName().lowercased().contains(value.lowercased())
            
            if isIncomplete && (nameMatch || descriptionMatch) {
                completeTasks.append(task)
            }
        }
        
        return completeTasks
    }
    
    func getTaskByIndex(index: Int) -> Task {
        return taskList[index]
    }
    
    func getLastID() -> Int {
        if taskList.count > 0 {
            return taskList[taskList.count - 1].getId()
        }
        
        return 0
    }
}
