//
//  HeadLinesListTableViewCell.swift
//  HeadLine
//
//  Created by Keerthika Chokkalingam on 03/09/23.
//

import UIKit

class HeadLinesListTableViewCell: UITableViewCell {

    @IBOutlet weak var imageContentView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sourceNameLabel: UILabel!
    @IBOutlet weak var headLineTitleLabel: UILabel!
    @IBOutlet weak var headLineNewsImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
