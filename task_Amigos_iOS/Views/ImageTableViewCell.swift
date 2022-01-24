//
//  ImageTableViewCell.swift
//  task_Amigos_iOS
//
//  Created by Daniel Miolan on 1/23/22.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
