//
//  HeadLinesListTableViewCell.swift
//  HeadLine
//
//  Created by Keerthika Chokkalingam on 03/09/23.
//

import UIKit

class HeadLinesListTableViewCell: UITableViewCell {

    @IBOutlet weak var headLineNewsImage: CustomImageView!
    @IBOutlet weak var imageContentView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sourceNameLabel: UILabel!
    @IBOutlet weak var headLineTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        headLineNewsImage.layer.cornerRadius = 10
        imageContentView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadCellValues(data: ArticalSet) {
        headLineNewsImage.loadImage(urlString: data.urlToImage ?? "")
        headLineTitleLabel.text = data.title
        dateLabel.text = Utils().convertUTCDateStringToFormattedDateString(utcDateString: data.publishedAt ?? "")
        sourceNameLabel.text = data.source?.name
    }
    
}
