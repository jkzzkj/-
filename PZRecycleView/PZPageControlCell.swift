//
//  ISSHomePageControlCellCollectionViewCell.swift
//  DLO
//
//  Created by 蒋泽康 on 2017/7/24.
//

import UIKit

class PZPageControlCell: UICollectionViewCell {
    
    var imageView :UIImageView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initImageView()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initImageView()
        
    }
    
    private func initImageView() {
        self.clipsToBounds = true
        
        if imageView == nil {
            imageView = UIImageView(frame:
                CGRect(x: 0,
                       y: 0,
                       width: self.frame.size.width,
                       height: self.frame.size.height))
        }
        
        self.contentView.addSubview(imageView!)
        
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraint(
            NSLayoutConstraint(item: self.contentView,
                               attribute: .left,
                               relatedBy: .equal,
                               toItem: imageView,
                               attribute: .left,
                               multiplier: 1,
                               constant: 0))
        self.contentView.addConstraint(
            NSLayoutConstraint(item: self.contentView,
                               attribute: .right,
                               relatedBy: .equal,
                               toItem: imageView,
                               attribute: .right,
                               multiplier: 1,
                               constant: 0))
        self.contentView.addConstraint(
            NSLayoutConstraint(item: self.contentView,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: imageView,
                               attribute: .top,
                               multiplier: 1,
                               constant: 0))
        self.contentView.addConstraint(
            NSLayoutConstraint(item: self.contentView,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: imageView,
                               attribute: .bottom,
                               multiplier: 1,
                               constant: 0))

    }
    
}
