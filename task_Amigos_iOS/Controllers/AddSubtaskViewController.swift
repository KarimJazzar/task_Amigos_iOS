//
//  AddSubtaskViewController.swift
//  task_Amigos_iOS
//
//  Created by Karim El Jazzar on 27/01/2022.
//

import UIKit

class AddSubtaskViewController: UIViewController {
    
    @IBOutlet weak var subName: UITextField!
    @IBOutlet weak var subDescription: UITextView!
    
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var categoryMenu: UIStackView!
    
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var statusMenuSub: UIStackView!
        
    @IBOutlet weak var statusStack: UIStackView!
    
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var createDate: UIDatePicker!
    
    @IBOutlet weak var deleteSubtaskButton: UIButton!
    @IBOutlet weak var addSubtaskButton: UIButton!
    
    var isEditMode: Bool = false
    var parentId: Int = -1
    var parentTask: Task?
    var taskSub: Task?
    var isNewTask: Bool = false
    var newTaskSubList: [Int] = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEditMode {
            addSubtaskButton.setTitle("Save", for: .normal)
            subName.text = taskSub?.getName()
            subDescription.text = taskSub?.getDescription()
            dueDate.date = (taskSub?.getDueDate())!
            createDate.date = (taskSub?.getCreatedDate())!
            
            deleteSubtaskButton.alpha = 1
            statusStack.alpha = 1
            addSubtaskButton.setTitle("Save", for: .normal)
        }else{
            deleteSubtaskButton.isHidden = true
            addSubtaskButton.setTitle("Add", for: .normal)
        }
    }
    
    @IBAction func showMenu(_ sender: UIButton) {
        if sender.tag == 0 {
            toggleMenuUI(menu: statusMenuSub, img: statusImg, alpha: 0)
            
            let tempAlpha = CGFloat(categoryMenu.alpha == 1 ? 0 : 1)
            toggleMenuUI(menu: categoryMenu, img: categoryImg, alpha: tempAlpha)
        } else {
            toggleMenuUI(menu: categoryMenu, img: categoryImg, alpha: 0)
            
            let tempAlpha = CGFloat(statusMenuSub.alpha == 1 ? 0 : 1)
            toggleMenuUI(menu: statusMenuSub, img: statusImg, alpha: tempAlpha)
        }
    }
    
    @IBAction func selectCategory(_ sender: UIButton) {
        toggleMenuUI(menu: categoryMenu, img: categoryImg, alpha: 0)
        updateAttributeTitle(btn: categoryBtn, newTitle: sender.currentTitle ?? "Work")
    }

    @IBAction func selectStatus(_ sender: UIButton) {
        toggleMenuUI(menu: statusMenuSub, img: statusImg, alpha: 0)
        updateAttributeTitle(btn: statusBtn, newTitle: sender.currentTitle ?? "Work")
    }
    
    
    @IBAction func addSubtask(_ sender: Any) {
        let name = subName.text!
        let desc = subDescription.text!
        let bname = categoryBtn.title(for: .normal) ?? ""
        let cat: Category = CategoryHelper.getCategoryByString(category: bname)
        
        let stat: Status
        if(statusBtn.title(for: .normal) == "Incomplete"){
            stat = Status.incomplete
        }else{
            stat = Status.complete
        }
        
        
       if name == "" {
           AlertHelper.showModal(view: self, type: AlertType.error, msg: "Task name can't be empty.")
            return
        }

       if desc == "" {
           AlertHelper.showModal(view: self, type: AlertType.error, msg: "Task description can't be empty.")
            return
        }
        
        if(isNewTask){
            if(isEditMode == false){
                let ind = taskManager.getLastID()+1
                let tempTask = Task(id: taskManager.getLastID()+1, name: name, description: desc, category: cat, status: stat, subTask: [], images: [], audios:[], dueDate: dueDate.date, createdDate: createDate.date, isSub: true)
                taskManager.addTask(task: tempTask, view: self)
                AddViewController.listOfSubtasks.subtasks.append(ind)
                clearFields()
                //parentTask?.appendSubtask(subId: tempTask.getId())
                //taskManager.updateTask(task: parentTask!)
                
            }else{
                let tempTask = Task(id: (taskSub?.getId())!, name: name, description: desc, category: cat, status: stat, subTask: [], images: [], audios:[], dueDate: dueDate.date, createdDate: createDate.date, isSub: true)
                taskManager.updateTask(task: tempTask, view: self)
                clearFields()
            }
        }else{
            if(isEditMode == false){
                let tempTask = Task(id: taskManager.getLastID()+1, name: name, description: desc, category: cat, status: stat, subTask: [], images: [], audios:[], dueDate: dueDate.date, createdDate: createDate.date, isSub: true)
                taskManager.addTask(task: tempTask, view: self)
                parentTask?.appendSubtask(subId: tempTask.getId())
                taskManager.updateTask(task: parentTask!, view: self)
                clearFields()
            }else{
                let tempTask = Task(id: (taskSub?.getId())!, name: name, description: desc, category: cat, status: stat, subTask: [], images: [], audios:[], dueDate: dueDate.date, createdDate: createDate.date, isSub: true)
                taskManager.updateTask(task: tempTask, view: self)
                clearFields()
            }
            
        }
        
        
    }
    
    @IBAction func deleteSubtask(_ sender: Any) {
        taskManager.remuveTaskById(id: (taskSub?.getId())!, view: self)
        performSegue(withIdentifier: "unwindToTaskEdit", sender: self)
        clearFields()
    }
    
    private func toggleMenuUI(menu: UIView, img: UIImageView, alpha: CGFloat) {
        menu.alpha = alpha
        
        if alpha == 1 {
            img.image = UIImage(systemName: "arrow.up.circle")
        } else {
            img.image = UIImage(systemName: "arrow.down.circle")
        }
    }
    
    private func clearFields() {
        subName.text = ""
        subDescription.text = ""
        categoryBtn.setTitle("Work", for: .normal)
        statusBtn.setTitle("Incomplete", for: .normal)
    }
    
    private func updateAttributeTitle(btn: UIButton, newTitle: String) {
        btn.setTitle(newTitle, for: .normal)
    }
}
