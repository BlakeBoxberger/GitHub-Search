//
//  GithubUserStyleOneCollectionViewCell.swift
//  GitHub Search
//
//  Created by Blake Boxberger on 9/6/20.
//  Copyright © 2020 Blake Boxberger. All rights reserved.
//

import UIKit

class GithubUserStyleOneCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var userOneImageView: UIImageView!
    @IBOutlet weak var userOneLabel: UILabel!
    @IBOutlet weak var userOneLabelBlurView: UIVisualEffectView!
    @IBOutlet weak var userTwoImageView: UIImageView!
    @IBOutlet weak var userTwoLabel: UILabel!
    @IBOutlet weak var userTwoLabelBlurView: UIVisualEffectView!
    
    var userOne:GithubUser! {
        didSet {
            self.userOneLabel.text = userOne.login
            self.userOneImageView.sd_setImage(with: URL(string:userOne.avatarURL), placeholderImage: #imageLiteral(resourceName: "github_icon"))
        }
    }
    
    var userTwo:GithubUser! {
        didSet {
            self.userTwoLabel.text = userTwo.login
            self.userTwoImageView.sd_setImage(with: URL(string:userTwo.avatarURL), placeholderImage: #imageLiteral(resourceName: "github_icon"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userOneImageView.layer.masksToBounds = true
        userOneImageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        userOneImageView.layer.cornerCurve = .continuous
        userOneImageView.layer.cornerRadius = 16.0
        
        userOneLabelBlurView.layer.masksToBounds = true
        userOneLabelBlurView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        userOneLabelBlurView.layer.cornerCurve = .continuous
        userOneLabelBlurView.layer.cornerRadius = 8.5
        
        userTwoImageView.layer.masksToBounds = true
        userTwoImageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        userTwoImageView.layer.cornerCurve = .continuous
        userTwoImageView.layer.cornerRadius = 16.0
        
        userTwoLabelBlurView.layer.masksToBounds = true
        userTwoLabelBlurView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        userTwoLabelBlurView.layer.cornerCurve = .continuous
        userTwoLabelBlurView.layer.cornerRadius = 8.5
    }
    
}
