//
//  PostListTableTableViewController.swift
//  Post
//
//  Created by Sean Gilhuly on 6/1/16.
//  Copyright © 2016 Sean Gilhuly. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {
    
    let postController = PostController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        postController.delegate = self
    }
    
    // MARK: - IBAction
    
    @IBAction func refreshControlPulled(sender: UIRefreshControl) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        postController.fetchPosts() { (newPosts) in
            sender.endRefreshing()
            
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath)
        
        let posts = postController.posts[indexPath.row]
        
        cell.textLabel?.text = posts.text
        cell.detailTextLabel?.text = "\(posts.username) - \(posts.timestamp)"
        
        return cell
    }
}

extension PostListTableViewController: PostControllerDelegate {
    
    func postsUpdated(posts: [Post]) {
        
        tableView.reloadData()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}