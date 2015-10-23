//
//  ConversationsViewController.swift
//  ChatApp
//
//  Created by Spencer Congero on 10/22/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit
import WatchConnectivity

class ConversationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate
{

    var bgColorRed: CGFloat = 1
    var bgColorGreen: CGFloat = 0.25
    var bgColorBlue: CGFloat = 0.25
    
    var conversationSearchBar: UISearchBar!
    var conversationTableView: UITableView!
    var logoutButton: UIButton!
    
    var searchXOffset: CGFloat = 150
    var searchYPos: CGFloat = 100
    var searchWidth: CGFloat = 300
    var searchHeight: CGFloat = 50
    
    var tableYPos: CGFloat = 150
    var tableHeight: CGFloat = 400
    
    var logoutXPos: CGFloat = 30
    var logoutYPos: CGFloat = 50
    var logoutWidth: CGFloat = 100
    var logoutHeight: CGFloat = 50
    
    var addXPos: CGFloat = 160
    var addWidth: CGFloat = 50
    
    var searchActive : Bool = false
    var conversations: [Dictionary<String,AnyObject>] = []
    var filteredConversations: [Dictionary<String,AnyObject>] = []
    
    var cellIdentifier = "cell"
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:bgColorRed, green:bgColorGreen, blue:bgColorBlue, alpha:1.0)
        
        _addLogoutButton()
        _addSearchBar()
        _addTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        _getConversations()
    }
    
    // MARK: - Internal methods
    
    func logoutPressed(sender: UIButton!)
    {
        User.logout()
        do {
            let session = WCSession.defaultSession()
            let applicationDict = ["type": "logout"]
            try session.updateApplicationContext(applicationDict)
        }
        catch {
            print("ERROR - failed to logout watch app")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UISearchBarDelegate methods
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        self.searchActive = true;
        _correctSearchActive()
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
        
        self.filteredConversations = self.conversations.filter({ (conversation) -> Bool in
            var conversationTitle = ""
            if let convTitle = conversation["title"] {
                conversationTitle = convTitle as! String
            }
            else {
                var userObjects = conversation["userObjects"] as! [Dictionary<String,AnyObject>]
                for var k = 0; k < userObjects.count; ++k {
                    let userObject = userObjects[k]
                    if ((userObject["uuid"] as! String) == UserDefaults.currentUserUuid()!) {
                        userObjects.removeAtIndex(k)
                    }
                }
                for var i = 0; i < userObjects.count; ++i {
                    let userObject = userObjects[i]
                    let firstName = userObject["firstName"] as! String
                    conversationTitle = conversationTitle.stringByAppendingString(firstName)
                    if (i != userObjects.count - 1) {
                        conversationTitle = conversationTitle.stringByAppendingString(", ")
                    }
                }
            }

            if (conversationTitle.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil) {
                return true
            }
            return false
        })
        if (self.filteredConversations.count == 0) {
            self.searchActive = false;
        } else {
            self.searchActive = true;
        }
        self.conversationTableView.reloadData()
    }
    
    // MARK: - UITableViewDelegate methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.searchActive) {
            return self.filteredConversations.count
        }
        return self.conversations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! ConversationsTableViewCell;
        
        var currentConversation = Dictionary<String,AnyObject>()
        
        if(searchActive) {
            if (indexPath.row < filteredConversations.count) {
                currentConversation = self.filteredConversations[indexPath.row]
            }
        } else {
            if (indexPath.row < conversations.count) {
                currentConversation = self.conversations[indexPath.row]
            }
        }
        
        var conversationTitle = ""
        if let convTitle = currentConversation["title"] {
            conversationTitle = convTitle as! String
        }
        else {
            var userObjects = currentConversation["userObjects"] as! [Dictionary<String,AnyObject>]
            for var k = 0; k < userObjects.count; ++k {
                let userObject = userObjects[k]
                if ((userObject["uuid"] as! String) == UserDefaults.currentUserUuid()!) {
                    userObjects.removeAtIndex(k)
                }
            }
            for var i = 0; i < userObjects.count; ++i {
                let userObject = userObjects[i]
                let firstName = userObject["firstName"] as! String
                conversationTitle = conversationTitle.stringByAppendingString(firstName)
                if (i != userObjects.count - 1) {
                    conversationTitle = conversationTitle.stringByAppendingString(", ")
                }
            }
        }
        cell.ConversationLabel?.text = conversationTitle
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddFriendTableViewCell
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: - Private methods
    
    private func _getConversations()
    {
        let manager = NetworkingManager.sharedInstance.manager
        let currentUserUuid = UserDefaults.currentUserUuid()
        
        manager.GET(User.userPath + currentUserUuid! + "/" + User.conversationsPathComponent,
            parameters: nil,
            success: { (dataTask: NSURLSessionDataTask!, responseObject: AnyObject!) in
                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                    let successful = jsonResult["success"] as? Bool
                    if (successful == false) {
                        print("Failed to get all conversations of user")
                    }
                    else if (successful == true) {
                        self.conversations = jsonResult["conversations"] as! [Dictionary<String, AnyObject>]
                        
                        self.conversationTableView.reloadData()
                    }
                }
                else {
                    print("Error: responseObject couldn't be converted to Dictionary")
                }
            },
            failure: { (dataTask: NSURLSessionDataTask!, error: NSError!) in
                let errorMessage = "Error: " + error.localizedDescription
                print(errorMessage)
                
                if let response = dataTask.response as? NSHTTPURLResponse {
                    if (response.statusCode == 401) {
                        NetworkingManager.sharedInstance.credentialStore.clearSavedCredentials()
                    }
                }
            }
        )
    }
    
    private func _correctSearchActive()
    {
        self.searchActive = false
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
    
    private func _addSearchBar()
    {
        self.conversationSearchBar = UISearchBar.init(frame: CGRectMake(self.view.center.x - searchXOffset, searchYPos, searchWidth, searchHeight))
        self.conversationSearchBar.searchBarStyle = UISearchBarStyle.Minimal
        let textFieldInsideSearchBar = conversationSearchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.whiteColor()
        self.conversationSearchBar.alpha = 0.9
        
        self.conversationSearchBar.delegate = self
        self.view.addSubview(conversationSearchBar)
    }
    
    private func _addTableView()
    {
        self.conversationTableView = UITableView.init(frame: CGRectMake(self.view.center.x - searchXOffset, tableYPos, searchWidth, tableHeight), style: UITableViewStyle.Plain)
        self.conversationTableView.backgroundColor = UIColor(red:bgColorRed, green:bgColorGreen, blue:bgColorBlue, alpha:1.0)
        self.conversationTableView.separatorColor = UIColor.whiteColor()
        
        self.conversationTableView.registerClass(ConversationsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        self.conversationTableView.delegate = self
        self.conversationTableView.dataSource = self
        
        self.view.addSubview(conversationTableView)
    }

}
