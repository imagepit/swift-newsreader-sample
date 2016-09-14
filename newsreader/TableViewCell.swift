//
//  TableViewCell.swift
//  newsreader
//
//  Created by 高橋良輔 on 2016/09/14.
//  Copyright © 2016年 imagepit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import WebImage

class TableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var link: String! {
        didSet {
            Alamofire.request(.GET, "http://api.hitonobetsu.com/ogp/analysis?url=\(link)")
                .responseJSON { response in
                    guard let object = response.result.value else {
                        return
                    }
                    let json = JSON(object)
                    if let imageUrlStr:String = json["image"].string{
                        let imageUrl = NSURL(string: imageUrlStr)
                        self.setThumbnailWithFadeInAnimation(imageUrl)
                    }
            }
        }
    }
    
    func setThumbnailWithFadeInAnimation(imageUrl: NSURL!){
        self.thumbnailImageView.sd_setImageWithURL(imageUrl, placeholderImage: nil, completed: {
            (image, error, cacheType, url) ->Void in
            self.thumbnailImageView.alpha = 0
            UIView.animateWithDuration(0.25,
                animations: {
                    self.thumbnailImageView.alpha = 1
                    self.indicator.stopAnimating()
                    self.indicator.alpha = 0
            })
        })
    }
}
