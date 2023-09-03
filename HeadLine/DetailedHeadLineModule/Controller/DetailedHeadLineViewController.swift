//
//  DetailedHeadLineViewController.swift
//  HeadLine
//
//  Created by Keerthika Chokkalingam on 03/09/23.
//

import UIKit

class DetailedHeadLineViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
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
                    self.setButtonTextColor(fromImage: image!)
                }
            }
            headLinesTitleLabel.text = gettedArticleSet?.title
            headLinesDateLabel.text = Utils().convertUTCDateStringToFormattedDateString(utcDateString: gettedArticleSet?.publishedAt ?? "")
            headLinesSourceNameLabel.text = gettedArticleSet?.source?.name
            headLinesDescription.text = gettedArticleSet?.description
        }
    }
    func setButtonTextColor(fromImage image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            return
        }
        let context = CIContext(options: nil)
        let roiRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let renderedImage = context.createCGImage(ciImage, from: roiRect)
        let averageColor = renderedImage?.averageColor ?? .white
        let textColor: UIColor = averageColor.isLight ? .black : .white
        backButton.tintColor = textColor
        headLinesTitleLabel.textColor = textColor
        headLinesDateLabel.textColor = textColor
        headLinesSourceNameLabel.textColor = textColor
        headLinesDescription.textColor = textColor
    }
    
    @IBAction func backToHeadlinesPage(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CGImage {
    var averageColor: UIColor {
        guard let pixelData = dataProvider?.data else { return .clear }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var totalRed = 0
        var totalGreen = 0
        var totalBlue = 0
        
        for x in 0..<width {
            for y in 0..<height {
                let pixelInfo: Int = ((Int(width) * Int(y)) + Int(x)) * 4
                let red = CGFloat(data[pixelInfo])
                let green = CGFloat(data[pixelInfo + 1])
                let blue = CGFloat(data[pixelInfo + 2])
                totalRed += Int(red)
                totalGreen += Int(green)
                totalBlue += Int(blue)
            }
        }
        
        let count = width * height
        let red = CGFloat(totalRed) / CGFloat(count)
        let green = CGFloat(totalGreen) / CGFloat(count)
        let blue = CGFloat(totalBlue) / CGFloat(count)
        
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1.0)
    }
}

extension UIColor {
    var isLight: Bool {
        var white: CGFloat = 0.0
        getWhite(&white, alpha: nil)
        return white > 0.5
    }
}
