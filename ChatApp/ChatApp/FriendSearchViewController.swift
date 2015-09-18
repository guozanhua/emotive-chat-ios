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
    var addFriendsButton: UIButton!
    
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
    
    var addXPos: CGFloat = 160
    var addWidth: CGFloat = 50
    
    var searchActive : Bool = false
    var friends: [Dictionary<String,String>] = []
    var filteredFriends: [Dictionary<String,String>] = []
    var settingsButton: UIButton!
        
    var cellIdentifier = "cell"
    
    // MARK: - UIViewController methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:bgColorRed, green:bgColorGreen, blue:bgColorBlue, alpha:1.0)
        
        _addLogoutButton()
        _addSettingsButton()
        _addAddFriendsButton()
        _addSearchBar()
        _addTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        _getFriends()
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
    
    func addFriendsPressed(sender: UIButton!)
    {
        let modalStyle = UIModalTransitionStyle.CoverVertical
        let addFriendsVC = AddFriendViewController()
        addFriendsVC.modalTransitionStyle = modalStyle
        self.presentViewController(addFriendsVC, animated: true, completion: nil)
    }
    
    // MARK: - UISearchBarDelegate methods
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        self.searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar)
    {
        self.searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        self.searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        self.searchActive = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filteredFriends = self.friends.filter({ (friend) -> Bool in
            let fullName: String = friend["firstName"]! + friend["lastName"]!
            if (fullName.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil) {
                return true
            }
            return false
        })
        if (self.filteredFriends.count == 0) {
            self.searchActive = false;
        } else {
            self.searchActive = true;
        }
        self.friendTableView.reloadData()
    }
    
    // MARK: - UITableViewDelegate methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.searchActive) {
            return self.filteredFriends.count
        }
        return self.friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! FriendsTableViewCell;
        
        
        if(searchActive) {
            if (indexPath.row < filteredFriends.count) {
                cell.userUuid = self.filteredFriends[indexPath.row]["uuid"]
                cell.nameLabel?.text = self.filteredFriends[indexPath.row]["firstName"]! + " " + self.filteredFriends[indexPath.row]["lastName"]!
            }
        } else {
            if (indexPath.row < friends.count) {
                cell.userUuid = self.friends[indexPath.row]["uuid"]
                cell.nameLabel?.text = self.friends[indexPath.row]["firstName"]! + " " + self.friends[indexPath.row]["lastName"]!
            }
        }
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddFriendTableViewCell
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    // MARK: - Private methods
        
    private func _getFriends()
    {
        let manager = NetworkingManager.sharedInstance.manager
        let currentUserUuid = UserDefaults.currentUserUuid()
        
        manager.GET(User.userPath + currentUserUuid + "/" + User.friendsPathComponent,
            parameters: nil,
            success: { (dataTask: NSURLSessionDataTask!, responseObject: AnyObject!) in
                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                    let successful = jsonResult["success"] as? Bool
                    if (successful == false) {
                        print("Failed to get all friends of user")
                    }
                    else if (successful == true) {
                        self.friends = jsonResult["friends"] as! [Dictionary<String, String>]
                        
                        self.friendTableView.reloadData()
                    }
                }
                else {
                    print("Error: responseObject coudln't be converted to Dictionary")
                }
            },
            failure: { (dataTask: NSURLSessionDataTask!, error: NSError!) in
                let errorMessage = "Error: " + error.localizedDescription
                print(errorMessage)
                
                if let response = dataTask.response as? NSHTTPURLResponse {
                    if (response.statusCode == 401) {
                        NetworkingManager.sharedInstance.credentialStore.setAuthToken(nil)
                    }
                }
            }
        )
    }
    
    private func _addAddFriendsButton()
    {
        self.addFriendsButton = UIButton()
        self.addFriendsButton.setTitle("Add", forState: .Normal)
        self.addFriendsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.addFriendsButton.frame = CGRectMake(addXPos, logoutYPos, addWidth, logoutHeight)
        self.addFriendsButton.addTarget(self, action: "addFriendsPressed:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.addFriendsButton)
    }

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
        
        self.friendTableView.registerClass(FriendsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        self.friendTableView.delegate = self
        self.friendTableView.dataSource = self
        
        self.view.addSubview(friendTableView)
    }
    
}
