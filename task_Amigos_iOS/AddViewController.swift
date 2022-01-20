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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentDateTime = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: currentDateTime)
        createdDate.text = dateString
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
