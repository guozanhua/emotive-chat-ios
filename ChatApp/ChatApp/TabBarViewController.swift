//
//  TabBarViewController.swift
//  ChatApp
//
//  Created by Spencer Congero on 10/23/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var friendsViewController: UIViewController?
        var conversationsViewController: UIViewController?
        var settingsViewController: UIViewController?
        
        // tab bar
        friendsViewController = FriendSearchViewController()
        conversationsViewController = ConversationsViewController()
        settingsViewController = SettingsViewController()
        
        self.viewControllers = [friendsViewController!, conversationsViewController!, settingsViewController!]
        
        let friendsItem = UITabBarItem(title: "Friends", image: nil, tag: 0)
        let conversationsItem = UITabBarItem(title: "Conversations", image: nil, tag: 1)
        let settingsItem = UITabBarItem(title: "Settings", image: nil, tag: 2)
        
        friendsViewController?.tabBarItem = friendsItem
        conversationsViewController?.tabBarItem = conversationsItem
        settingsViewController?.tabBarItem = settingsItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {

    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
