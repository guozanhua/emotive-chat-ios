//
//  FriendsTableViewCell.swift
//  ChatApp
//
//  Created by Spencer Congero on 9/4/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    var nameLabel: UILabel!
    
    // MARK: - UITableViewCell methods
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(red:0.00, green:0.82, blue:1.00, alpha:1.0)
        
        self.nameLabel = UILabel(frame: CGRectMake(20.0, 0.0, 300.0, 50.0))
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
