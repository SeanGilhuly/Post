//
//  PostController.swift
//  Post
//
//  Created by Sean Gilhuly on 6/1/16.
//  Copyright © 2016 Sean Gilhuly. All rights reserved.
//

import Foundation

class PostController {
    
    static let baseURL = NSURL(string: "https://devmtn-post.firebaseio.com")
    
    static let endpoint = baseURL?.URLByAppendingPathComponent("/posts.json")
    
    weak var delegate: PostControllerDelegate?
    
    var posts: [Post] = [] {
        didSet {
            delegate?.postsUpdated(posts)
        }
    }
    
    init() {
        fetchPosts()
    }
    
    //MARK: - Request
    
    func fetchPosts(completion: ((newPosts: [Post]) -> Void)? = nil) {
        guard let url = PostController.endpoint else { fatalError("URL optional (endpoint) is nil") }
        
        //This puts the URL request on a "back thread" or "background" because we are saying to do so in the Network Controller by calling the "NSURLSession"
        NetworkController.performRequestForURL(url, httpMethod: .Get, urlParameters: nil) { (data, error) in
            
            //This captures and prints a readable representation of the returned data
            let responseDataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            guard let data = data,
                
                //NSJSONSerialization converts JSON to Foundation objects
                let postDictionaries = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String:[String:AnyObject]] else {
                    
                    print("Unable to serialize JSON. \nResponse: \(responseDataString)")
                    if let completion = completion {
                        completion(newPosts: [])
                    }
                    return
            }
            
            //flatMap is going through all the dictionaries and returning the data that we asked for in our Post.Swift file
            //It helps us extract specific values from mutli-dimensional arrays
            //$0 inside of the flatMap refers to one of the arrays inside the array of arrays
            let posts = postDictionaries.flatMap {Post(dictionary: $0.1, identifier: $0.0)}
            
            //Since dictionaries are not properly sorted, call the "sort" function to put in reverse chronological order
            //We are sorting the dictionaries from last to first, by when they were created (timestamp)
            // Ie. [Post.Post, Post.Post]
            let sortedPosts = posts.sort({$0.0.timestamp > $0.1.timestamp})
            
            //This is to bring all the data back on the main thread, since it is currently being run on the "background" or "back thread"
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.posts = sortedPosts
                
                if let completion = completion {
                    completion(newPosts: sortedPosts)
                } else {
                    print("No data returned from Network Request.")
                    
                    if let completion = completion {
                        completion(newPosts: [])
                    }
                    return
                }
            })
        }
    }
}
protocol PostControllerDelegate: class {
    
    func postsUpdated(posts: [Post])
}