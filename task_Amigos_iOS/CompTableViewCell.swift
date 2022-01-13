//
//  CompTableViewCell.swift
//  task_Amigos_iOS
//
//  Created by Karim El Jazzar on 13/01/2022.
//

import UIKit

class CompTableViewCell: UITableViewCell {

    @IBOutlet weak var nameT: UILabel!
    
    @IBOutlet weak var dateT: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTask(name:String, date:String){
        nameT.text = name
        dateT.text = date
    }

}
