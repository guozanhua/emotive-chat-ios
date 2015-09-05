//
//  FriendSearchViewController.swift
//  ChatApp
//
//  Created by Spencer Congero on 9/4/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit

class FriendSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate
{
    var bgColorRed: CGFloat = 0
    var bgColorGreen: CGFloat = 0.82
    var bgColorBlue: CGFloat = 1
    
    var friendSearchBar: UISearchBar!
    var friendTableView: UITableView!
    var logoutButton: UIButton!
    
    var searchXOffset: CGFloat = 150
    var searchYPos: CGFloat = 100
    var searchWidth: CGFloat = 300
    var searchHeight: CGFloat = 50
    
    var tableYPos: CGFloat = 150
    var tableHeight: CGFloat = 400
    
    var settingsXPos: CGFloat = 240
    var settingsYPos: CGFloat = 50
    var settingsWidth: CGFloat = 100
    var settingsHeight: CGFloat = 50
    
    var logoutXPos: CGFloat = 30
    var logoutYPos: CGFloat = 50
    var logoutWidth: CGFloat = 100
    var logoutHeight: CGFloat = 50
    
    var searchActive : Bool = false
    var friends = ["Rahul Madduluri", "Spencer Congero", "Jack Kellner", "Steve Nam", "Sean Allgood"]
    var filtered:[String] = []
    var settingsButton: UIButton!
    
    // MARK: - UIViewController methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:bgColorRed, green:bgColorGreen, blue:bgColorBlue, alpha:1.0)
        
        _addLogoutButton()
        _addSettingsButton()
        _addSearchBar()
        _addTableView()
    }
    
    // MARK: - Internal methods
    
    func logoutPressed(sender: UIButton!)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func settingsPressed(sender: UIButton!)
    {
        let modalStyle = UIModalTransitionStyle.FlipHorizontal
        let settingsVC = SettingsViewController()
        settingsVC.modalTransitionStyle = modalStyle
        self.presentViewController(settingsVC, animated: true, completion: nil)
        
    }
    
    // MARK: - UISearchBarDelegate methods
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar)
    {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchActive = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = friends.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if (filtered.count == 0) {
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.friendTableView.reloadData()
    }
    
    // MARK: - UITableViewDelegate methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! FriendsTableViewCell;
        
        
        if(searchActive) {
            cell.nameLabel?.text = filtered[indexPath.row]
        } else {
            cell.nameLabel?.text = friends[indexPath.row];
        }
        
        return cell;
    }

    
    // MARK: - Private methods

    private func _addLogoutButton()
    {
        self.logoutButton = UIButton()
        self.logoutButton.setTitle("Log Out", forState: .Normal)
        self.logoutButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.logoutButton.frame = CGRectMake(logoutXPos, logoutYPos, logoutWidth, logoutHeight)
        self.logoutButton.addTarget(self, action: "logoutPressed:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.logoutButton)
    }
    
    private func _addSettingsButton()
    {
        self.settingsButton = UIButton()
        self.settingsButton.setTitle("Settings", forState: .Normal)
        self.settingsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.settingsButton.frame = CGRectMake(settingsXPos, settingsYPos, settingsWidth, settingsHeight)
        self.settingsButton.addTarget(self, action: "settingsPressed:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.settingsButton)
    }
    
    private func _addSearchBar()
    {
        self.friendSearchBar = UISearchBar.init(frame: CGRectMake(self.view.center.x - searchXOffset, searchYPos, searchWidth, searchHeight))
        self.friendSearchBar.searchBarStyle = UISearchBarStyle.Minimal
        let textFieldInsideSearchBar = friendSearchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.whiteColor()
        self.friendSearchBar.alpha = 0.9
        
        self.friendSearchBar.delegate = self
        self.view.addSubview(friendSearchBar)
    }
    
    private func _addTableView()
    {
        self.friendTableView = UITableView.init(frame: CGRectMake(self.view.center.x - searchXOffset, tableYPos, searchWidth, tableHeight), style: UITableViewStyle.Plain)
        self.friendTableView.backgroundColor = UIColor(red:bgColorRed, green:bgColorGreen, blue:bgColorBlue, alpha:1.0)
        self.friendTableView.separatorColor = UIColor.whiteColor()
        
        self.friendTableView.registerClass(FriendsTableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.friendTableView.delegate = self
        self.friendTableView.dataSource = self
        
        self.view.addSubview(friendTableView)
    }
    
}
