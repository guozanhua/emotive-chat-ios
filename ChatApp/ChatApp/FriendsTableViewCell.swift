//
//  FriendsTableViewCell.swift
//  ChatApp
//
//  Created by Spencer Congero on 9/4/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell
{
    var bgColorRed: CGFloat = 0
    var bgColorGreen: CGFloat = 0.82
    var bgColorBlue: CGFloat = 1
    
    var nameLabelXPos: CGFloat = 20
    var nameLabelYPos: CGFloat = 0
    var nameLabelWidth: CGFloat = 300
    var nameLabelHeight: CGFloat = 50
    
    var nameLabel: UILabel!
    
    // MARK: - UITableViewCell methods
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(red:bgColorRed, green:bgColorGreen, blue:bgColorBlue, alpha:1.0)
        
        self.nameLabel = UILabel(frame: CGRectMake(nameLabelXPos, nameLabelYPos, nameLabelWidth, nameLabelHeight))
        self.nameLabel.textColor = UIColor.whiteColor()
        
        self.addSubview(nameLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
