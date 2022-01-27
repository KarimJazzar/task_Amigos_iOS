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
    
    var task: Task?
    var isEditMode: Bool = false
    private var subtaskList: [Int] = [Int]()
    private var audioList: [String] = [String]()
    private var imagesList: [String] = [String]()
    private let currentDateTime = Date()
    
    private var isAttachViewVisible = false
    private var currentTable = 0
    private let selectedColor: UIColor = UIColor(red: 47/255, green: 46/255, blue: 54/255, alpha: 1.0)
    private var gestureList: [UISwipeGestureRecognizer.Direction] = [.left, .right]
    
    var imagePicker = UIImagePickerController()
    
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
        
        dueDatePicker.setValue(UIColor.white, forKey: "backgroundColor")
        createdDatePicker.setValue(UIColor.white, forKey: "backgroundColor")
        infoTapBtn.roundTopCorners()
        attachTapBtn.roundTopCorners()
        
        if isEditMode {
            toggleEditMode(deleteAlpha: 1, statusAlpha: 1, saveTitle: "Save")
            fillFields()
        }
    }
    
    func toggleEditMode(deleteAlpha: CGFloat, statusAlpha: CGFloat, saveTitle: String) {
        deleteBtn.alpha = deleteAlpha
        statusStackView.alpha = statusAlpha
        saveBtn.setTitle("Save", for: .normal)
    }
    
    func fillFields() {
        print("\(task?.getId() ?? -1)")
        subtaskList = task?.getSubTask() ?? []
        imagesList = task?.getImages() ?? []
        audioList = task?.getAudios() ?? []
        nameTF.text = task?.getName() ?? ""
        descriptionTV.text = task?.getDescription() ?? ""
        
        let tempCategory = CategoryHelper.getCategoryString(category:task?.getCategory() ?? Category.work)
        categoryBtn.setTitle(tempCategory, for: .normal)
        
        dueDatePicker.date = task?.getDueDate() ?? currentDateTime
        createdDatePicker.date = task?.getCreatedDate() ?? currentDateTime
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == subTaskTableView {
            return subtaskList.count
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
            cell.subTaskName.text = "Subtask #\(indexPath.row)"
            
            return cell
        } else if tableView == imageTableView {
            let cell = imageTableView.dequeueReusableCell(withIdentifier: "imageCellView") as! ImageTableViewCell
            cell.imgName.text = "Image #\(indexPath.row)"
            
            cell.imgView.image = loadImageFromDocumentDirectory(name: imagesList[indexPath.row])
            //cell.imgView.image = loadImageFromDocumentDirectory(name: "2022-01-27 18:19:27 +0000.png")
            
            return cell
        } else {
            let cell = audioTableView.dequeueReusableCell(withIdentifier: "audioCellView") as! AudioTableViewCell
            cell.audioName.text = "Audio #\(indexPath.row)"
            
            return cell
        }
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
        then you have to use popoverPresentationController to present the actionsheet,
        otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender.self
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)

    }
    
    func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openGallery() {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let editedImage = info[.editedImage] as? UIImage {
            
            guard let fileUrl = info[.imageURL] as? URL else { return }
            
            print("haii" + fileUrl.lastPathComponent)
            
            let tempName = Date()
            saveImageToDocumentDirectory(image: editedImage, name: "\(tempName).png")
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveImageToDocumentDirectory(image: UIImage, name: String) {
        guard let data = image.pngData() else {
            print("Error getting data.")
            return
        }
        
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let path = directory.appendingPathComponent("\(name)")
        
        do {
            print("============")
            print("\(path)")
            print("============")
            try data.write(to: path)
            imagesList.append(name)
            imageTableView.reloadData()
            print("IMAGE SAVED")
        } catch let error {
            print("\(error)")
        }
    }
    
    func loadImageFromDocumentDirectory(name : String) -> UIImage {
        let emptyImg = UIImage(systemName: "doc")!
        
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first  else {
            return emptyImg
        }
        
        let path = directory.appendingPathComponent("\(name)")
        
        do {
            let imageData = try Data(contentsOf: path)
            print("=================================")
            print("\(name)")
            print("\(path)")
            print("\(imageData)")
            print("=================================")
            return UIImage(data: imageData) ?? emptyImg
        } catch let error {
            print("\(error)")
        }
        
        return emptyImg
   }
    
    @IBAction func showMenu(_ sender: UIButton) {
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
    
    func toggleMenuUI(menu: UIView, img: UIImageView, alpha: CGFloat) {
        menu.alpha = alpha
        
        if alpha == 1 {
            img.image = UIImage(systemName: "arrow.up.circle")
        } else {
            img.image = UIImage(systemName: "arrow.down.circle")
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
    
    private func updateAttributeTitle(btn: UIButton, newTitle: String) {
        btn.setTitle(newTitle, for: .normal)
    }
    
    @IBAction func toggleTapView(_ sender: UIButton) {
        isAttachViewVisible = sender.tag == 1
        
        if sender.tag == 0 {
            changeTapView(infoColor: selectedColor, attachColor: .clear, infoAlpha: 1, attachAlpha: 0)
        } else {
            changeTapView(infoColor: .clear, attachColor: selectedColor, infoAlpha: 0, attachAlpha: 1)
        }
    }
    
    private func changeTapView(infoColor: UIColor, attachColor: UIColor, infoAlpha: CGFloat, attachAlpha: CGFloat) {
        infoTapBtn.backgroundColor = infoColor
        attachTapBtn.backgroundColor = attachColor
        infoTapView.alpha = infoAlpha
        attachTapView.alpha = attachAlpha
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
            AlertHelper.showValidationAlert(view: self, msg: "Task name can't be empty.")
            return
        }
        
        if desc == "" {
            AlertHelper.showValidationAlert(view: self, msg: "Task description can't be empty.")
            return
        }
        
        let tempTask = Task(id: taskManager.getLastID(), name: name, description: desc, category: cat, status: stat, subTask: subtaskList, images: imagesList, audios:audioList, dueDate: dueDatePicker.date, createdDate: createdDatePicker.date)
        
        if isEditMode {
            taskManager.updateTask(task: tempTask)
        } else {
            taskManager.addTask(task: tempTask, view: self)
            
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func deleteTask(_ sender: Any) {
        let id = task?.getId() ?? -1
        
        if id >= 0 {
            taskManager.remuveTaskById(id: id)
            
            subtaskList = []
            imagesList = []
            audioList = []
            nameTF.text = ""
            descriptionTV.text =  ""
            
            let tempCategory = CategoryHelper.getCategoryString(category: Category.work)
            categoryBtn.setTitle(tempCategory, for: .normal)
            
            dueDatePicker.date = currentDateTime
            createdDatePicker.date = currentDateTime
        }
        
        isEditMode = false
        toggleEditMode(deleteAlpha: 0, statusAlpha: 0, saveTitle: "Add")
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
}
