//
//  AddViewController.swift
//  task_Amigos_iOS
//
//  Created by Karim El Jazzar on 20/01/2022.
//

import UIKit
import CoreData

class AddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var managedContext: NSManagedObjectContext!

    var tasks: [Task]?
    
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
    @IBOutlet weak var imageTableView: UITableView!
    @IBOutlet weak var audioTableView: UITableView!
    
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var createdDatePicker: UIDatePicker!
    
    let currentDateTime = Date()
    var task: Task?
    var imageTestRows: Int = 10
    var audiosTestRows: Int = 3
    private var gestureList: [UISwipeGestureRecognizer.Direction] = [.left, .right]
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        imageTableView.delegate = self
        imageTableView.dataSource = self
        
        audioTableView.delegate = self
        audioTableView.dataSource = self
        
        imagePicker.delegate = self
        
        for gesture in gestureList {
            let tempSwipe = UISwipeGestureRecognizer(target: self, action: #selector(PerformSwipe))
            tempSwipe.direction = gesture
            view.addGestureRecognizer(tempSwipe)
        }
        
        dueDatePicker.setValue(UIColor.white, forKey: "backgroundColor")
        createdDatePicker.setValue(UIColor.white, forKey: "backgroundColor")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == imageTableView {
            return imageTestRows
        } else {
            return audiosTestRows
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
        if tableView == imageTableView {
            let cell = imageTableView.dequeueReusableCell(withIdentifier: "imageCellView") as! ImageTableViewCell
            cell.imgName.text = "Image #\(indexPath.row)"
            
            cell.imgView.image = loadImageFromDocumentDirectory(nameOfImage: "C215868E-F864-4BAF-8847-B36F1565B3E3")
            
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
    
    func openCamera()
        {
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
            {
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            else
            {
                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    

    func openGallery()
        {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)

            
        }
    
   
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let editedImage = info[.editedImage] as? UIImage{

            let cell = imageTableView.dequeueReusableCell(withIdentifier: "imageCellView") as! ImageTableViewCell
            
            
            guard let fileUrl = info[.imageURL] as? URL else { return }
                print("haii" + fileUrl.lastPathComponent)
            
            cell.imgView.image = editedImage
            
            saveImageToDocumentDirectory(image: editedImage, imgname: fileUrl.lastPathComponent)
            
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveImageToDocumentDirectory(image: UIImage, imgname: String) {
        var objCBool: ObjCBool = true
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        let folderPath = mainPath + "/Screenshots/"

        let isExist = FileManager.default.fileExists(atPath: folderPath, isDirectory: &objCBool)
        if !isExist {
            do {
                try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }

        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageName = "\(imgname).png"
        let imageUrl = documentDirectory.appendingPathComponent("Screenshots/\(imageName)")
        if let data = image.jpegData(compressionQuality: 1.0){
            do {
                try data.write(to: imageUrl)
                
                print("saved ", imageUrl)
            } catch {
                print("error saving", error)
            }
        }
    }
    
    func loadImageFromDocumentDirectory(nameOfImage : String) -> UIImage {
       let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
       let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
       let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
       if let dirPath = paths.first{
           let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("Screenshots/\(nameOfImage)")
           guard let image = UIImage(contentsOfFile: imageURL.path)
           else { return  UIImage.init(named: "C215868E-F864-4BAF-8847-B36F1565B3E3.png")!}
           return image
       }
       return UIImage.init(named: "C215868E-F864-4BAF-8847-B36F1565B3E3.png")!
   }
    
    @IBAction func ShowMenu(_ sender: UIButton) {
        if sender.tag == 0 {
            ToggleMenuUI(menu: statusMenu, img: statusImg, alpha: 0)
            
            let tempAlpha = CGFloat(categoryMenu.alpha == 1 ? 0 : 1)
            ToggleMenuUI(menu: categoryMenu, img: categoryImg, alpha: tempAlpha)
        } else {
            ToggleMenuUI(menu: categoryMenu, img: categoryImg, alpha: 0)
            
            let tempAlpha = CGFloat(statusMenu.alpha == 1 ? 0 : 1)
            ToggleMenuUI(menu: statusMenu, img: statusImg, alpha: tempAlpha)
        }
    }
    
    func ToggleMenuUI(menu: UIView, img: UIImageView, alpha: CGFloat) {
        menu.alpha = alpha
        
        if alpha == 1 {
            img.image = UIImage(systemName: "arrow.up.circle")
        } else {
            img.image = UIImage(systemName: "arrow.down.circle")
        }
    }
    
    @IBAction func SelectCategory(_ sender: UIButton) {
        ToggleMenuUI(menu: categoryMenu, img: categoryImg, alpha: 0)
        UpdateAttributeTitle(btn: categoryBtn, newTitle: sender.titleLabel?.text ?? "Work")
    }
    
    @IBAction func SelectStatus(_ sender: UIButton) {
        ToggleMenuUI(menu: statusMenu, img: statusImg, alpha: 0)
        UpdateAttributeTitle(btn: statusBtn, newTitle: sender.titleLabel?.text ?? "Incomplete")
    }
    
    func UpdateAttributeTitle(btn: UIButton, newTitle: String) {
        if let attributedTitle = btn.attributedTitle(for: .normal) {
            let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
            
            mutableAttributedTitle.replaceCharacters(in: NSMakeRange(0, mutableAttributedTitle.length), with: newTitle)
            btn.setAttributedTitle(mutableAttributedTitle, for: .normal)
        }
    }
    
    @IBAction func SaveTask(_ sender: Any) {
        
        let name = nameTF.text!
        let desc = descriptionTV.text!
        let bname = categoryBtn.title(for: .normal)
        let cat: Category
        if(bname == "Groceries"){
            cat = Category.groceries
        }else if(bname == "School"){
            cat = Category.school
        }else if(bname == "Shopping"){
            cat = Category.shopping
        }else{
            cat = Category.work
        }
        
        let stat: Status
        if(statusBtn.title(for: .normal) == "Incomplete"){
            stat = Status.incomplete
        }else{
            stat = Status.complete
        }
        
        addTask(t: Task(id: 0, name: name, description: desc, category: cat, status: stat, subTask: [1,2], images: ["hello", "world"], audios: ["za", "wurdo"], dueDate: dueDatePicker.date, createdDate: createdDatePicker.date))
        self.performSegue(withIdentifier: "exitAfterAdding", sender: self)
        
    }
    
    @IBAction func DeleteTask(_ sender: Any) {
        
    }
    
    @objc func PerformSwipe(gesture: UISwipeGestureRecognizer) -> Void {
        let swipeGesture = gesture as UISwipeGestureRecognizer
        
        switch swipeGesture.direction {
            case .left:
                let newX = UIScreen.main.bounds.width - audioView.frame.width - 15
                AnimationHelper.SlideX(view: audioView, x: newX)
                AnimationHelper.SlideX(view: imageView, x: newX - imageView.frame.width - 15)
                break
            case .right:
                AnimationHelper.SlideX(view: audioView, x: audioView.frame.width + 30)
                AnimationHelper.SlideX(view: imageView, x: 15)
                break
            default:
                break
        }
    }
    
    
    //function to add a task to core data
    func addTask(t:Task){
                
                let newTask = NSEntityDescription.insertNewObject(forEntityName: "TaskEntity", into: managedContext)
                
                newTask.setValue(t.getName(), forKey: "name")
                newTask.setValue(t.getDescription(), forKey: "desc")
                newTask.setValue(t.getStatus().rawValue, forKey: "status")
                newTask.setValue(t.getSubTask(), forKey: "subtask")
                newTask.setValue(t.getImages(), forKey: "images")
                newTask.setValue(t.getAudios(), forKey: "audios")
                newTask.setValue(t.getDueDate(), forKey: "dueDate")
                newTask.setValue(t.getCreatedDate(), forKey: "createdDate")
                newTask.setValue(t.getCategory().rawValue, forKey: "category")

                do {
                    try managedContext.save()
                    print("Record Added!")
                    //To display an alert box
//                    let alertController = UIAlertController(title: "Message", message: "Task Added!", preferredStyle: .alert)
//                    let OKAction = UIAlertAction(title: "OK", style: .default) {
//                        (action: UIAlertAction!) in
//                    }
                    //alertController.addAction(OKAction)
                    //self.present(alertController, animated: true, completion: nil)
                } catch
                let error as NSError {
                    print("Could not save. \(error),\(error.userInfo)")
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
    
    }
