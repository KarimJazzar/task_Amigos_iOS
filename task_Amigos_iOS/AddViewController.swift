//
//  AddViewController.swift
//  task_Amigos_iOS
//
//  Created by Karim El Jazzar on 20/01/2022.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var taskName: UITextField!
    
    @IBOutlet weak var taskDescription: UITextView!
    
    let currentDateTime = Date()
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: currentDateTime)
        createdDate.text = dateString
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addTaskSegue"){
            let dest = segue.destination as? ViewController
            dest?.incompleteTasks.append(task!)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func add(_ sender: UIButton) {
        //task = Task(name: taskName.text!, description: taskDescription.text, category: , status: , subTask: , images: , audios: , dueDate: , createdDate: currentDateTime)
        performSegue(withIdentifier: "addTaskSegue", sender: <#T##Any?#>)
    }
    
}
