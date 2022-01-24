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
    @IBOutlet weak var imageTableView: UITableView!
    @IBOutlet weak var audioTableView: UITableView!
    
    let currentDateTime = Date()
    var task: Task?
    var imageTestRows: Int = 10
    var audiosTestRows: Int = 3
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
    
    @IBAction func Saveask(_ sender: Any) {
        
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
}
