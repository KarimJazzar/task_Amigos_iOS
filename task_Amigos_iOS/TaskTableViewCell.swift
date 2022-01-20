//
//  TaskTableViewCell.swift
//  task_Amigos_iOS
//
//  Created by Daniel Miolan on 1/20/22.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryColorLine: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
