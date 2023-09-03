//
//  DetailedHeadLineViewController.swift
//  HeadLine
//
//  Created by Keerthika Chokkalingam on 03/09/23.
//

import UIKit

class DetailedHeadLineViewController: UIViewController {

    @IBOutlet weak var headLinesDescription: UILabel!
    @IBOutlet weak var headLinesSourceNameLabel: UILabel!
    @IBOutlet weak var headLinesDateLabel: UILabel!
    @IBOutlet weak var headLinesTitleLabel: UILabel!
    @IBOutlet weak var headLinewsNewsImageView: UIImageView!
    
    var gettedArticleSet: ArticalSet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    func setUpUI() {
        if gettedArticleSet != nil {
            Utils().downloadImage(from: (gettedArticleSet?.urlToImage)!) { image in
                DispatchQueue.main.async {
                    self.headLinewsNewsImageView.image = image
                }
            }
            headLinesTitleLabel.text = gettedArticleSet?.title
            headLinesDateLabel.text = Utils().convertUTCDateStringToFormattedDateString(utcDateString: gettedArticleSet?.publishedAt ?? "")
            headLinesSourceNameLabel.text = gettedArticleSet?.source?.name
            headLinesDescription.text = gettedArticleSet?.description
        }
    }
    @IBAction func backToHeadlinesPage(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
