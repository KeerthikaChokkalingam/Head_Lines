//
//  DetailedHeadLineViewController.swift
//  HeadLine
//
//  Created by Keerthika Chokkalingam on 03/09/23.
//

import UIKit

class DetailedHeadLineViewController: UIViewController {
    
    @IBOutlet weak var headLinewsNewsImageView: CustomImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headLinesDescription: UILabel!
    @IBOutlet weak var headLinesSourceNameLabel: UILabel!
    @IBOutlet weak var headLinesDateLabel: UILabel!
    @IBOutlet weak var headLinesTitleLabel: UILabel!
    
    var gettedArticleSet: ArticalSet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    func setUpUI() {
        if gettedArticleSet != nil {
            headLinewsNewsImageView.loadImage(urlString: gettedArticleSet?.urlToImage ?? "")
            headLinesTitleLabel.text = gettedArticleSet?.title
            headLinesDateLabel.text = Utils().convertUTCDateStringToFormattedDateString(utcDateString: gettedArticleSet?.publishedAt ?? "")
            headLinesSourceNameLabel.text = gettedArticleSet?.source?.name
            headLinesDescription.text = gettedArticleSet?.description
        }
    }
    
    @IBAction func backToHeadlinesPage(_ sender: UIButton) {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
