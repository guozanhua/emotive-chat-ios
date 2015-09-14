//
//  FriendsTableViewCell.swift
//  ChatApp
//
//  Created by Spencer Congero on 9/4/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit

class AddFriendTableViewCell: UITableViewCell
{
    var bgColorRed: CGFloat = 244/255
    var bgColorGreen: CGFloat = 179/255
    var bgColorBlue: CGFloat = 80/255
    
    var nameLabelXPos: CGFloat = 20
    var nameLabelYPos: CGFloat = 0
    var nameLabelWidth: CGFloat = 300
    var nameLabelHeight: CGFloat = 50
    
    var selectedLabelXPos: CGFloat = 260
    var selectedLabelYPos: CGFloat = 0
    var selectedLabelWidth: CGFloat = 100
    var selectedLabelHeight: CGFloat = 50
    
    var nameLabel: UILabel!
    var selectedLabel: UILabel!
    var hiddenIDLabel: UILabel!
    
    // MARK: - UITableViewCell methods
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(red:bgColorRed, green:bgColorGreen, blue:bgColorBlue, alpha:1.0)
        
        self.nameLabel = UILabel(frame: CGRectMake(nameLabelXPos, nameLabelYPos, nameLabelWidth, nameLabelHeight))
        self.nameLabel.textColor = UIColor.whiteColor()
        
        self.selectedLabel = UILabel(frame: CGRectMake(selectedLabelXPos, selectedLabelYPos, selectedLabelWidth, selectedLabelHeight))
        self.selectedLabel.textColor = UIColor.greenColor()
        self.selectedLabel.text = "o"
        self.selectedLabel.hidden = true
        
        self.hiddenIDLabel = UILabel.init()
        self.hiddenIDLabel.hidden = true
        
        self.addSubview(nameLabel)
        self.addSubview(selectedLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
