//
//  IncompleteTableViewCell.swift
//  task_Amigos_iOS
//
//  Created by Karim El Jazzar on 13/01/2022.
//

import UIKit

class IncompleteTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    

    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTask(nameT:String, dateT:String){
        name.text = nameT
        date.text = dateT
    }

}
