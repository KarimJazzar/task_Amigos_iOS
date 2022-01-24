//
//  ViewController.swift
//  task_Amigos_iOS
//
//  Created by Karim El Jazzar on 12/01/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var taskList: [Task] = [Task]()
    private var incompleteTasks: [Task] = [Task]()
    private var completeTasks: [Task] = [Task]()
    private var gestureList: [UISwipeGestureRecognizer.Direction] = [.left, .right]
    
    @IBOutlet weak var incompleteView: UIView!
    @IBOutlet weak var completeView: UIView!
    @IBOutlet weak var incompleteTableView: UITableView!
    @IBOutlet weak var completeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
}

