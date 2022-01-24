//
//  ViewController.swift
//  task_Amigos_iOS
//
//  Created by Karim El Jazzar on 12/01/2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var managedContext: NSManagedObjectContext!
    
    var tasks: [Task]?
    var taskList: [Task] = [Task]()
    var incompleteTasks: [Task] = [Task]()
    var completeTasks: [Task] = [Task]()
    private var gestureList: [UISwipeGestureRecognizer.Direction] = [.left, .right]
    
    @IBOutlet weak var incompleteView: UIView!
    @IBOutlet weak var completeView: UIView!
    @IBOutlet weak var incompleteTableView: UITableView!
    @IBOutlet weak var completeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        managedContext = appDelegate.persistentContainer.viewContext
        
        incompleteTableView.delegate = self
        incompleteTableView.dataSource = self
        
        completeTableView.delegate = self
        completeTableView.dataSource = self
        
        for gesture in gestureList {
            let tempSwipe = UISwipeGestureRecognizer(target: self, action: #selector(PerformSwipe))
            tempSwipe.direction = gesture
            view.addGestureRecognizer(tempSwipe)
        }
        
        var tempTask = Task(id: 0, name: "Incomplete Task 1", description: "This is an example of incomplete task.", category: Category.work, status: Status.incomplete, subTask: [Int](), images: [String](), audios: [String](), dueDate: Date(), createdDate: Date())
        
        taskList.append(tempTask)
        incompleteTasks.append(tempTask)
        
        tempTask = Task(id: 0, name: "Incomplete Task 2", description: "This is an example of incomplete task.", category: Category.school, status: Status.incomplete, subTask: [Int](), images: [String](), audios: [String](), dueDate: Date(), createdDate: Date())
        
        taskList.append(tempTask)
        incompleteTasks.append(tempTask)
        
        tempTask = Task(id: 0, name: "Complete Task 1", description: "This is an example of complete task.", category: Category.groceries, status: Status.complete, subTask: [Int](), images: [String](), audios: [String](), dueDate: Date(), createdDate: Date())
        
        taskList.append(tempTask)
        completeTasks.append(tempTask)
        
        tempTask = Task(id: 0, name: "Complete Task 2", description: "This is an example of complete task.", category: Category.shopping, status: Status.complete, subTask: [Int](), images: [String](), audios: [String](), dueDate: Date(), createdDate: Date())
        
        taskList.append(tempTask)
        completeTasks.append(tempTask)

        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {}, completion: { finished in self.completeView.frame.origin.x = (self.completeView.frame.origin.x * 2) + self.completeView.frame.width
        })
        
        
        //clearTaskData()
        
        //testing core data
//        addTask(t: Task(id: 0, name: "Dio", description: "This is an example of incomplete task.", category: Category.school, status: Status.incomplete, subTask: [1,2], images: ["hello", "world"], audios: ["za", "wurdo"], dueDate: Date(), createdDate: Date()))
//        addTask(t: Task(id: 0, name: "Jotarou", description: "This is an example of incomplete task.", category: Category.school, status: Status.incomplete, subTask: [1,2], images: ["hello", "world"], audios: ["za", "wurdo"], dueDate: Date(), createdDate: Date()))
//
        loadTasks()
        print("There are \(tasks?.count) tasks")
        for t in tasks!{
            print("Task name is \(t.getName())")
            print(t.getAudios())
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == completeTableView {
            return completeTasks.count
        } else {
            return incompleteTasks.count
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 8

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 5    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x + 5, y: cell.bounds.origin.y, width: cell.bounds.width - 10, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isCompleteTable = tableView == completeTableView
        let cell = CheckCellType(isCompleteTable: isCompleteTable)
        let tempTask = isCompleteTable ? completeTasks[indexPath.row] : incompleteTasks[indexPath.row]
        let color = CategoryHelper.GetCategoryColor(category: tempTask.getCategory())

        cell.categoryColorLine.backgroundColor = color
        cell.categoryLabel.text = CategoryHelper.GetCategoryString(category: tempTask.getCategory())
        cell.categoryLabel.textColor = color
        cell.taskName.text = "\(tempTask.getName())"
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd-MM-yyy"
        cell.dueDate.text = "\(dateFormat.string(from: tempTask.getDueDate()))"
    
        return cell
    }
    
    private func CheckCellType(isCompleteTable: Bool) -> TaskTableViewCell {
        if isCompleteTable {
            return completeTableView.dequeueReusableCell(withIdentifier: "taskCellComplete") as! TaskTableViewCell
        } else {
            return incompleteTableView.dequeueReusableCell(withIdentifier: "taskCellIncomplete") as! TaskTableViewCell
        }
    }
    
    // Check swipe direction
    @objc func PerformSwipe(gesture: UISwipeGestureRecognizer) -> Void {
        let swipeGesture = gesture as UISwipeGestureRecognizer
        
        switch swipeGesture.direction {
            case .left:
                let newX = UIScreen.main.bounds.width - completeView.frame.width - 15
                AnimationHelper.SlideX(view: completeView, x: newX)
                AnimationHelper.SlideX(view: incompleteView, x: newX - incompleteView.frame.width - 15)
                break
            case .right:
                AnimationHelper.SlideX(view: completeView, x: completeView.frame.width + 30)
                AnimationHelper.SlideX(view: incompleteView, x: 15)
                break
            default:
                break
        }
    }
    
    func SlideAnimation(view: UIView, x: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            view.frame.origin.x = CGFloat(x)
        }
    }
    
    //function to load tasks from core data
    func loadTasks() {
            tasks = [Task]()
            
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
                        
                            tasks?.append(Task(id: 0, name: name, description: descr, category: Category(rawValue: cat)!, status: Status(rawValue: status)!, subTask: subtask, images: images, audios: audios, dueDate: dueDate, createdDate: createdDate))
                    }
                }
                
            } catch {
                print(error)
            }
        }
    
    // function to delete all tasks from core data
    func clearTaskData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")

        do {
            let managedContext = appDelegate.persistentContainer.viewContext
            let results = try managedContext.fetch(fetchRequest)
            for result in results {
                if let managedObject = result as? NSManagedObject {
                    managedContext.delete(managedObject)
                }
            }
        } catch {
            print("Error deleting records \(error)")
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let avc = segue.destination as! AddViewController
//        avc.tasks = tasks
//    }
//
//    @IBAction func moveToAdd(_ sender: Any) {
//        performSegue(withIdentifier: "AddT", sender: tasks)
//    }
    
}

