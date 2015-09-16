//
//  FriendSearchViewController.swift
//  ChatApp
//
//  Created by Spencer Congero on 9/4/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit

class AddFriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate
{
    var bgColorRed: CGFloat = 244/255
    var bgColorGreen: CGFloat = 179/255
    var bgColorBlue: CGFloat = 80/255
    
    var friendSearchBar: UISearchBar!
    var friendTableView: UITableView!
    var doneButton: UIButton!
    
    var searchXOffset: CGFloat = 150
    var searchYPos: CGFloat = 100
    var searchWidth: CGFloat = 300
    var searchHeight: CGFloat = 50
    
    var tableYPos: CGFloat = 150
    var tableHeight: CGFloat = 400

    var doneXPos: CGFloat = 30
    var doneYPos: CGFloat = 50
    var doneWidth: CGFloat = 100
    var doneHeight: CGFloat = 50
    
    var searchActive : Bool = false
    var friends = [[String]]()
    var friendNames: [String] = []
    var filtered:[String] = []
    var settingsButton: UIButton!
    
    var selectedFriends = NSMutableSet()
        
    var cellIdentifier = "cell"
    
    var selectedIndexPaths = NSMutableSet()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:bgColorRed, green:bgColorGreen, blue:bgColorBlue, alpha:1.0)
        
        _getPotentialFriends()
        
        _addDoneButton()
        _addSearchBar()
        _addTableView()
    }
    
    // MARK: - Internal methods
    
    func donePressed(sender: UIButton!)
    {
        let manager = NetworkingManager.sharedInstance.manager

        let friendsArray = self.selectedFriends.allObjects
        let currentUserUuid = UserDefaults.currentUserUuid()
        let parameters = ["uuid": currentUserUuid, "newFriends": friendsArray]
        
        manager.PUT(User.userPath + currentUserUuid,
            parameters: parameters,
            success: {
                (dataTask: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                    let successful = jsonResult["success"] as? Bool
                    if (successful == false) {
                        print("Failed to update new user")
                    }
                    else if (successful == true) {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
                else {
                    print("Error: responseObject coudln't be converted to Dictionary")
                }
            }, failure: {
                (dataTask: NSURLSessionDataTask!, error: NSError!) -> Void in
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
        
        filtered = self.friendNames.filter({ (text) -> Bool in
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! AddFriendTableViewCell;
        
        cell.userUuid = self.friends[indexPath.row][1]
        
        if(searchActive) {
            cell.nameLabel?.text = filtered[indexPath.row]
        } else {
            let name = self.friendNames[indexPath.row] as String?
            cell.nameLabel?.text = name
        }
        
        _configure(cell, forRowAtIndexPath: indexPath)
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddFriendTableViewCell
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let friendUuid = cell.userUuid as String!
        if (selectedIndexPaths.containsObject(indexPath)) {
            self.selectedFriends.removeObject(friendUuid)
            self.selectedIndexPaths.removeObject(indexPath)
        }
        else {
            self.selectedFriends.addObject(friendUuid)
            self.selectedIndexPaths.addObject(indexPath)
        }
        _configure(cell, forRowAtIndexPath: indexPath)
    }
    
    // MARK: - Private methods
    
    private func _configure(cell: AddFriendTableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if (selectedIndexPaths.containsObject(indexPath)) {
            cell.selectedLabel.hidden = false
        }
        else {
            cell.selectedLabel.hidden = true
        }
    }
    
    private func _getPotentialFriends()
    {
        let manager = NetworkingManager.sharedInstance.manager
        let parameters = ["ignoreFriendsOfUserWithUuid": UserDefaults.currentUserUuid()]
        
        manager.GET(User.userPath,
            parameters: parameters,
            success: { (dataTask: NSURLSessionDataTask!, responseObject: AnyObject!) in
                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                    let successful = jsonResult["success"] as? Bool
                    if (successful == false) {
                        print("Failed to get all potential friends")
                    }
                    else if (successful == true) {
                        self.friends = jsonResult["friends"] as! [[String]]
                        
                        self.friendNames = []
                        
                        for friend in self.friends {
                            self.friendNames.append(friend[0])
                        }
                        
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
    
    private func _addDoneButton()
    {
        self.doneButton = UIButton()
        self.doneButton.setTitle("Done", forState: .Normal)
        self.doneButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.doneButton.frame = CGRectMake(doneXPos, doneYPos, doneWidth, doneHeight)
        self.doneButton.addTarget(self, action: "donePressed:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.doneButton)
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
        
        self.friendTableView.registerClass(AddFriendTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        self.friendTableView.delegate = self
        self.friendTableView.dataSource = self
        
        self.view.addSubview(friendTableView)
    }
    
}
