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
    
    var post: [Post]
    
    init() {
        self.post = []
    }
    
    
    static func fetchPosts(completion: ((posts: [Post]) -> Void)) {
        guard let url = self.baseURL else { fatalError("URL optional is nil") }
        
        NetworkController.performRequestForURL(url, httpMethod: .Get) { (data, error) in
            if let data = data,
                responseDataString = NSString(data: data, encoding: NSUTF8StringEncoding) {
                guard let responseDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String:AnyObject],
                    postDictionaries = responseDictionary["posts"] as? [[String:AnyObject]] else {
                        print("Unable to serialize JSON. \nResponse: \(responseDataString)")
                        completion(posts: [])
                        return
                }
                let posts = postDictionaries.flatMap {Post(dictionary: $0)}
                completion(posts: posts)
            } else {
                print("No data returned from Network Request.")
                completion(posts: [])
            }
        }
    }
}