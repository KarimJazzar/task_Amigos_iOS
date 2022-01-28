//
//  ViewController.swift
//  task_Amigos_iOS
//
//  Created by Karim El Jazzar on 12/01/2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    var incompleteTasks: [Task] = [Task]()
    var completeTasks: [Task] = [Task]()
    private var didFixPosition: Bool =  false
    private var gestureList: [UISwipeGestureRecognizer.Direction] = [.left, .right]
    
    @IBOutlet weak var incompleteView: UIView!
    @IBOutlet weak var completeView: UIView!
    @IBOutlet weak var incompleteTableView: UITableView!
    @IBOutlet weak var completeTableView: UITableView!
    @IBOutlet weak var selectedSort: UIButton!
    @IBOutlet weak var sortMenu: UIStackView!
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchInput: UITextField!
    @IBOutlet weak var filterMenu: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        incompleteTableView.delegate = self
        incompleteTableView.dataSource = self
        
        completeTableView.delegate = self
        completeTableView.dataSource = self
        
        for gesture in gestureList {
            let tempSwipe = UISwipeGestureRecognizer(target: self, action: #selector(performSwipe))
            tempSwipe.direction = gesture
            view.addGestureRecognizer(tempSwipe)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        filterMenu.layer.frame.origin.x =  -filterMenu.frame.width
        filterMenu.alpha = 1
        filterMenu.translatesAutoresizingMaskIntoConstraints = true
    }
    
  

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        incompleteTasks = taskManager.getIncompleteTasksList()
        completeTasks = taskManager.getCompleteTasksList()
        
        incompleteTableView.reloadData()
        completeTableView.reloadData()
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
        maskLayer.cornerRadius = 5  //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x + 5, y: cell.bounds.origin.y, width: cell.bounds.width - 10, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isCompleteTable = tableView == completeTableView
        let cell = checkCellType(isCompleteTable: isCompleteTable)
        let tempTask = isCompleteTable ? completeTasks[indexPath.row] : incompleteTasks[indexPath.row]
        let color = CategoryHelper.getCategoryColor(category: tempTask.getCategory())

        cell.categoryColorLine.backgroundColor = color
        cell.categoryLabel.text = CategoryHelper.getCategoryString(category: tempTask.getCategory())
        cell.categoryLabel.textColor = color
        cell.taskName.text = "\(tempTask.getName())"
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd-MM-yyy"
        cell.dueDate.text = "\(dateFormat.string(from: tempTask.getDueDate()))"
    
        return cell
    }
    
    //table view clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        
        vc.isEditMode = true
        
        if tableView == completeTableView {
            vc.task = completeTasks[indexPath.row]
        } else {
            vc.task = incompleteTasks[indexPath.row]
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func toggleFilter(_ sender: UIButton) {
        if sender.tag == 0 {
            AnimationHelper.fade(view: overlay, alpha: 1)
            AnimationHelper.slideX(view: filterMenu, x: 0)
        } else {
            AnimationHelper.fade(view: overlay, alpha: 0)
            AnimationHelper.slideX(view: filterMenu, x: -filterMenu.frame.width)
        }
    }
    
    @IBAction func showSortMenu(_ sender: Any) {
        let tempAlpha = CGFloat(sortMenu.alpha == 1 ? 0 : 1)
        toggleSortMenu(alpha: tempAlpha)
    }
    
    @IBAction func selectSortType(_ sender: UIButton) {
        toggleSortMenu(alpha: 0)
        selectedSort.setTitle(sender.currentTitle, for: .normal)
    }
    
    
    private func toggleSortMenu(alpha: CGFloat) {
        sortMenu.alpha = alpha
    }
    
    private func checkCellType(isCompleteTable: Bool) -> TaskTableViewCell {
        if isCompleteTable {
            return completeTableView.dequeueReusableCell(withIdentifier: "taskCellComplete") as! TaskTableViewCell
        } else {
            return incompleteTableView.dequeueReusableCell(withIdentifier: "taskCellIncomplete") as! TaskTableViewCell
        }
    }
    
    // Check swipe direction
    @objc func performSwipe(gesture: UISwipeGestureRecognizer) -> Void {
        let swipeGesture = gesture as UISwipeGestureRecognizer
        
        switch swipeGesture.direction {
            case .left:
                let newX = UIScreen.main.bounds.width - completeView.frame.width - 15
                AnimationHelper.slideX(view: completeView, x: newX)
                AnimationHelper.slideX(view: incompleteView, x: newX - incompleteView.frame.width - 15)
                break
            case .right:
                AnimationHelper.slideX(view: completeView, x: completeView.frame.width + 30)
                AnimationHelper.slideX(view: incompleteView, x: 15)
                break
            default:
                break
        }
    }
}

