//
//  GithubUserStyleThreeCollectionViewCell.swift
//  GitHub Search
//
//  Created by Blake Boxberger on 9/6/20.
//  Copyright © 2020 Blake Boxberger. All rights reserved.
//

import UIKit

class GithubUserStyleThreeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userLabelBlurView: UIVisualEffectView!
    
    var user:GithubUser! {
        didSet {
            self.userLabel.text = user.login
            self.userImageView.sd_setImage(with: URL(string:user.avatarURL), placeholderImage: #imageLiteral(resourceName: "github_icon"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.masksToBounds = true
        userImageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        userImageView.layer.cornerCurve = .continuous
        userImageView.layer.cornerRadius = 16.0
        
        userLabelBlurView.layer.masksToBounds = true
        userLabelBlurView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        userLabelBlurView.layer.cornerCurve = .continuous
        userLabelBlurView.layer.cornerRadius = 8.5
    }
}
