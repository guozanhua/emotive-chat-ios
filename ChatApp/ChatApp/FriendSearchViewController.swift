//
//  FriendSearchViewController.swift
//  ChatApp
//
//  Created by Spencer Congero on 9/4/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit

class FriendSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var friendSearchBar: UISearchBar!
    var friendTableView: UITableView!
    
    var searchActive : Bool = false
    var friends = ["Rahul Madduluri", "Spencer Congero", "Jack Kellner", "Steve Nam", "Sean Allgood"]
    var filtered:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendSearchBar = UISearchBar.init(frame: CGRectMake(self.view.center.x - 150.0, 100.0, 300.0, 50.0))
        self.friendTableView = UITableView.init(frame: CGRectMake(self.view.center.x - 150.0, 150.0, 300.0, 400.0), style: UITableViewStyle.Plain)
        
        self.friendTableView.delegate = self
        self.friendTableView.dataSource = self
        self.friendSearchBar.delegate = self
        
        self.friendTableView.registerClass(FriendsTableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.backgroundColor = UIColor.orangeColor()
        
        self.view.addSubview(friendSearchBar)
        self.view.addSubview(friendTableView)

        // Do any additional setup after loading the view.
    }
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
