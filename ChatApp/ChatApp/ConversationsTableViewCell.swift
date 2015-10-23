//
//  ConversationsTableViewCell.swift
//  ChatApp
//
//  Created by Spencer Congero on 10/22/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit

class ConversationsTableViewCell: UITableViewCell {

    var bgColorRed: CGFloat = 1
    var bgColorGreen: CGFloat = 0.25
    var bgColorBlue: CGFloat = 0.25
    
    var nameLabelXPos: CGFloat = 20
    var nameLabelYPos: CGFloat = 0
    var nameLabelWidth: CGFloat = 300
    var nameLabelHeight: CGFloat = 50
    
    var ConversationLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(red:bgColorRed, green:bgColorGreen, blue:bgColorBlue, alpha:1.0)
        
        self.ConversationLabel = UILabel(frame: CGRectMake(nameLabelXPos, nameLabelYPos, nameLabelWidth, nameLabelHeight))
        self.ConversationLabel.textColor = UIColor.whiteColor()
        
        self.addSubview(ConversationLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UITableViewCell methods
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
