//
//  AudioTableViewCell.swift
//  task_Amigos_iOS
//
//  Created by Daniel Miolan on 1/23/22.
//

import UIKit

class AudioTableViewCell: UITableViewCell {

    
    @IBOutlet weak var audioImage: UIImageView!
    @IBOutlet weak var audioName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
