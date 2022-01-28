//
//  AddViewController.swift
//  task_Amigos_iOS
//
//  Created by Karim El Jazzar on 20/01/2022.
//

import UIKit

class AddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var categoryMenu: UIStackView!
    
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var statusMenu: UIStackView!
    
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var subTaskView: UIView!
    @IBOutlet weak var imageTableView: UITableView!
    @IBOutlet weak var audioTableView: UITableView!
    @IBOutlet weak var subTaskTableView: UITableView!
    
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var createdDatePicker: UIDatePicker!
    
    
    @IBOutlet weak var infoTapBtn: UIButton!
    @IBOutlet weak var attachTapBtn: UIButton!
    @IBOutlet weak var infoTapView: UIView!
    @IBOutlet weak var attachTapView: UIView!
    
    
    @IBOutlet weak var statusStackView: UIStackView!
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    struct listOfSubtasks {
        static var subtasks: [Int] = [Int]()
    }
    
    var subTasks: [Task] = [Task]()
    var task: Task?
    var isEditMode: Bool = false
    private let imagesManager = ImagesManager()
    private var subtaskList: [Int] = [Int]()
    private var audioList: [String] = [String]()
    private var imagesList: [String] = [String]()
    private var imagesListBackup: [String] = [String]()
    private let currentDateTime = Date()
    private var imagePicker = UIImagePickerController()
    private var isAttachViewVisible = false
    private var currentTable = 0
    private let selectedColor: UIColor = UIColor(red: 47/255, green: 46/255, blue: 54/255, alpha: 1.0)
    private var gestureList: [UISwipeGestureRecognizer.Direction] = [.left, .right]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageTableView.delegate = self
        imageTableView.dataSource = self
        
        audioTableView.delegate = self
        audioTableView.dataSource = self
        
        imagePicker.delegate = self
        
        subTaskTableView.delegate = self
        subTaskTableView.dataSource = self
        
        
        for gesture in gestureList {
            let tempSwipe = UISwipeGestureRecognizer(target: self, action: #selector(performSwipe))
            tempSwipe.direction = gesture
            view.addGestureRecognizer(tempSwipe)
        }
        
        imagesManager.setUpManager(view: self, imagePicker: imagePicker)
        
        dueDatePicker.setValue(UIColor.white, forKey: "backgroundColor")
        createdDatePicker.setValue(UIColor.white, forKey: "backgroundColor")
        infoTapBtn.roundTopCorners()
        attachTapBtn.roundTopCorners()
        
        if isEditMode {
            toggleEditMode(deleteAlpha: 1, statusAlpha: 1, saveTitle: "Save")
            fillFields()
        }
        subTasks.removeAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subTasks.removeAll()
        super.viewWillAppear(animated)
        let subTemp = taskManager.getSubtasks()
        if(task != nil){
            for taskS in subTemp{
                if(task!.getSubTask().contains(taskS.getId())){
                    subTasks.append(taskS)
                }
            }
        }else{
            subtaskList = listOfSubtasks.subtasks
            for taskS in subTemp{
                for i in subtaskList{
                    if(taskS.getId() == i){
                        subTasks.append(taskS)
                    }
                }
            }
        }
        //subTasks = taskManager.getSubtasks()
        subTaskTableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("Is Edit Mode: \(isEditMode)")
        
        imagesManager.removeNotSavedImages(images: imagesListBackup)
    }
    
    // ImagePickerView behavior
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagesManager.savePicketmage(info: info)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    // Table view behaviors
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == subTaskTableView {
            return subTasks.count
        } else if tableView == imageTableView {
            return imagesList.count
        } else {
            return audioList.count
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
        if tableView == subTaskTableView {
            let cell = subTaskTableView.dequeueReusableCell(withIdentifier: "subTaskCellView") as! SubTaskTableViewCell
            //cell.subTaskName.text = "Subtask #\(indexPath.row)"

                if(subTasks[indexPath.row].getStatus() == Status.incomplete){
                    cell.subTaskName.text = "\( subTasks[indexPath.row].getName()) | Incomplete"
                }else{
                    cell.subTaskName.text = "\( subTasks[indexPath.row].getName()) | Complete"
                }
            
            
            return cell
        } else if tableView == imageTableView {
            let cell = imageTableView.dequeueReusableCell(withIdentifier: "imageCellView") as! ImageTableViewCell
            cell.imgName.text = "Image #\(indexPath.row)"
            cell.imgView.image = imagesManager.loadImage(name: imagesList[indexPath.row])
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
            
            return cell
        } else {
            let cell = audioTableView.dequeueReusableCell(withIdentifier: "audioCellView") as! AudioTableViewCell
            cell.audioName.text = "Audio #\(indexPath.row)"
            
            return cell
        }
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        imagesManager.generateView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editSub = self.storyboard?.instantiateViewController(withIdentifier: "AddSubtaskViewController") as! AddSubtaskViewController
        
        editSub.isEditMode = true
        
        if tableView == subTaskTableView {
            editSub.taskSub = subTasks[indexPath.row]
        }
        self.navigationController?.pushViewController(editSub, animated: true)
    }
    
    @IBAction func ShowMenu(_ sender: UIButton) {
        if sender.tag == 0 {
            toggleMenuUI(menu: statusMenu, img: statusImg, alpha: 0)
            
            let tempAlpha = CGFloat(categoryMenu.alpha == 1 ? 0 : 1)
            toggleMenuUI(menu: categoryMenu, img: categoryImg, alpha: tempAlpha)
        } else {
            toggleMenuUI(menu: categoryMenu, img: categoryImg, alpha: 0)
            
            let tempAlpha = CGFloat(statusMenu.alpha == 1 ? 0 : 1)
            toggleMenuUI(menu: statusMenu, img: statusImg, alpha: tempAlpha)
        }
    }
    
    @IBAction func selectCategory(_ sender: UIButton) {
        toggleMenuUI(menu: categoryMenu, img: categoryImg, alpha: 0)
        updateAttributeTitle(btn: categoryBtn, newTitle: sender.currentTitle ?? "Work")
    }
    
    @IBAction func selectStatus(_ sender: UIButton) {
        toggleMenuUI(menu: statusMenu, img: statusImg, alpha: 0)
        updateAttributeTitle(btn: statusBtn, newTitle: sender.currentTitle ?? "Work")
    }
    
    @IBAction func toggleTapView(_ sender: UIButton) {
        isAttachViewVisible = sender.tag == 1
        
        if sender.tag == 0 {
            changeTapView(infoColor: selectedColor, attachColor: .clear, infoAlpha: 1, attachAlpha: 0)
        } else {
            changeTapView(infoColor: .clear, attachColor: selectedColor, infoAlpha: 0, attachAlpha: 1)
        }
    }
    
    @IBAction func saveTask(_ sender: Any) {
        let name = nameTF.text!
        let desc = descriptionTV.text!
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
        
        
        
        imagesListBackup = imagesList
        if(isEditMode){
            let tempTask = Task(id: (task?.getId())!, name: name, description: desc, category: cat, status: stat, subTask: subtaskList, images: imagesList, audios:audioList, dueDate: dueDatePicker.date, createdDate: createdDatePicker.date, isSub: false)
            taskManager.updateTask(task: tempTask, view:self)
        } else {
            let tempTask = Task(id: taskManager.getLastID() + 1, name: name, description: desc, category: cat, status: stat, subTask: subtaskList, images: imagesList, audios:audioList, dueDate: dueDatePicker.date, createdDate: createdDatePicker.date, isSub: false)
            taskManager.addTask(task: tempTask, view: self)
            listOfSubtasks.subtasks.removeAll()
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            }
        }
        
        imagesManager.removeNotSavedImages(images: imagesListBackup)
    }
    
    @IBAction func deleteTask(_ sender: Any) {
        let id = task?.getId() ?? -1
        
        print("==============")
        print("ID: \(id)")
        print("==============")
        
        if id >= 0 {
            taskManager.remuveTaskById(id: id, view: self)
            clearFields()
            imagesListBackup.removeAll()
            imagesManager.removeNotSavedImages(images: imagesListBackup)
        }
        
        isEditMode = false
        toggleEditMode(deleteAlpha: 0, statusAlpha: 0, saveTitle: "Add")
        performSegue(withIdentifier: "exitAfterAdding", sender: self)
    }
    
    func updateImagesTable(images: [String]) {
        imagesList = images
        imageTableView.reloadData()
    }
    
    private func toggleMenuUI(menu: UIView, img: UIImageView, alpha: CGFloat) {
        menu.alpha = alpha
        
        if alpha == 1 {
            img.image = UIImage(systemName: "arrow.up.circle")
        } else {
            img.image = UIImage(systemName: "arrow.down.circle")
        }
    }
    
    private func toggleEditMode(deleteAlpha: CGFloat, statusAlpha: CGFloat, saveTitle: String) {
        deleteBtn.alpha = deleteAlpha
        statusStackView.alpha = statusAlpha
        saveBtn.setTitle("Save", for: .normal)
    }
    
    private func clearFields() {
        subtaskList.removeAll()
        imagesList.removeAll()
        audioList.removeAll()
        nameTF.text = ""
        descriptionTV.text =  ""
        
        let tempCategory = CategoryHelper.getCategoryString(category: Category.work)
        categoryBtn.setTitle(tempCategory, for: .normal)
        
        dueDatePicker.date = currentDateTime
        createdDatePicker.date = currentDateTime
        
        subTaskTableView.reloadData()
        imageTableView.reloadData()
        audioTableView.reloadData()
        
        changeTapView(infoColor: selectedColor, attachColor: .clear, infoAlpha: 1, attachAlpha: 0)
    }
    
    private func fillFields() {
        print("\(task?.getId() ?? -1)")
        subtaskList = task?.getSubTask() ?? []
        imagesList = task?.getImages() ?? []
        imagesListBackup = imagesList
        audioList = task?.getAudios() ?? []
        nameTF.text = task?.getName() ?? ""
        descriptionTV.text = task?.getDescription() ?? ""
        imagesManager.setImagesList(imagesList: imagesList)
        
        let tempCategory = CategoryHelper.getCategoryString(category:task?.getCategory() ?? Category.work)
        categoryBtn.setTitle(tempCategory, for: .normal)
        
        dueDatePicker.date = task?.getDueDate() ?? currentDateTime
        createdDatePicker.date = task?.getCreatedDate() ?? currentDateTime
    }
    
    private func updateTablePositions() {
        if currentTable == 0 {
            AnimationHelper.slideX(view: subTaskView, x: 15)
            AnimationHelper.slideX(view: imageView, x: subTaskView.frame.width + 30)
            AnimationHelper.slideX(view: audioView, x: (subTaskView.frame.width * 2) + 45)
        } else if currentTable == 1 {
            AnimationHelper.slideX(view: subTaskView, x: -subTaskView.frame.width)
            AnimationHelper.slideX(view: imageView, x: 15)
            AnimationHelper.slideX(view: audioView, x: subTaskView.frame.width + 30)
        } else {
            let newX = UIScreen.main.bounds.width - subTaskView.frame.width - 15
            AnimationHelper.slideX(view: imageView, x: newX - subTaskView.frame.width - 15)
            AnimationHelper.slideX(view: audioView, x: newX)
        }
    }
    

    @IBAction func addSubtaskButton(_ sender: Any) {
        let addSub = self.storyboard?.instantiateViewController(withIdentifier: "AddSubtaskViewController") as! AddSubtaskViewController
        
        if(isEditMode){
            addSub.parentTask = task
            addSub.isNewTask = false
        }else{
            addSub.newTaskSubList = subtaskList
            addSub.isNewTask = true
        }
        
        self.navigationController?.pushViewController(addSub, animated: true)
    }
    
    @IBAction func unwindToAddTask(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.subTaskTableView.reloadData()
            }
        }
    }
    
    
    
    private func changeTapView(infoColor: UIColor, attachColor: UIColor, infoAlpha: CGFloat, attachAlpha: CGFloat) {
        infoTapBtn.backgroundColor = infoColor
        attachTapBtn.backgroundColor = attachColor
        infoTapView.alpha = infoAlpha
        attachTapView.alpha = attachAlpha
    }
    
    private func updateAttributeTitle(btn: UIButton, newTitle: String) {
        btn.setTitle(newTitle, for: .normal)
    }
    
    @objc func deleteImage(_ sender: UIButton) {
        let index = sender.tag
        imagesList.remove(at: index)
        imageTableView.reloadData()
    }
    
    @objc func performSwipe(gesture: UISwipeGestureRecognizer) -> Void {
        if !isAttachViewVisible {
            return
        }
        
        let swipeGesture = gesture as UISwipeGestureRecognizer
        
        switch swipeGesture.direction {
            case .left:
                currentTable += 1
                currentTable = currentTable >= 2 ? 2 : currentTable
                break
            case .right:
                currentTable -= 1
                currentTable = currentTable <= 0 ? 0 : currentTable
                break
            default:
                break
        }
        
        updateTablePositions()
    }

}
