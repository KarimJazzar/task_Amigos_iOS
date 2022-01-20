//
//  ViewController.swift
//  task_Amigos_iOS
//
//  Created by Karim El Jazzar on 12/01/2022.
//

import UIKit

class ViewController: UIViewController {
    
    var taskList: [Task] = [Task]()
    @IBOutlet weak var incompleteView: UIView!
    @IBOutlet weak var completeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {}, completion: { finished in self.completeView.frame.origin.x = (self.completeView.frame.origin.x * 2) + self.completeView.frame.width
        })
    }
}

