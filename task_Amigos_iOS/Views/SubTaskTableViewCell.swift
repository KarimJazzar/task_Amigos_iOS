//
//  SubTaskTableViewCell.swift
//  task_Amigos_iOS
//
//  Created by Daniel Miolan on 1/26/22.
//

import UIKit

class SubTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var subTaskName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
