//
//  AddViewController.swift
//  task_Amigos_iOS
//
//  Created by Karim El Jazzar on 20/01/2022.
//

import UIKit

class AddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    
    let currentDateTime = Date()
    var task: Task?
    var imageTestRows: Int = 10
    var audiosTestRows: Int = 3
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
        
        for gesture in gestureList {
            let tempSwipe = UISwipeGestureRecognizer(target: self, action: #selector(PerformSwipe))
            tempSwipe.direction = gesture
            view.addGestureRecognizer(tempSwipe)
        }
        
        dueDatePicker.setValue(UIColor.white, forKey: "backgroundColor")
        createdDatePicker.setValue(UIColor.white, forKey: "backgroundColor")
        infoTapBtn.roundTopCorners()
        attachTapBtn.roundTopCorners()
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
            
            return cell
        } else {
            let cell = audioTableView.dequeueReusableCell(withIdentifier: "audioCellView") as! AudioTableViewCell
            cell.audioName.text = "Audio #\(indexPath.row)"
            
            return cell
        }
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
        UpdateAttributeTitle(btn: categoryBtn, newTitle: sender.currentTitle ?? "Work")
    }
    
    @IBAction func SelectStatus(_ sender: UIButton) {
        ToggleMenuUI(menu: statusMenu, img: statusImg, alpha: 0)
        UpdateAttributeTitle(btn: statusBtn, newTitle: sender.currentTitle ?? "Work")
    }
    
    private func UpdateAttributeTitle(btn: UIButton, newTitle: String) {
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
        
        let tempTask = Task(id: 0, name: name, description: desc, category: cat, status: stat, subTask: [1,2], images: ["hello", "world"], audios: ["za", "wurdo"], dueDate: dueDatePicker.date, createdDate: createdDatePicker.date)
        
        taskManager.addTask(task: tempTask, view: self)
        
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }
    
    @IBAction func DeleteTask(_ sender: Any) {
        
    }
    
    @objc func PerformSwipe(gesture: UISwipeGestureRecognizer) -> Void {
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
