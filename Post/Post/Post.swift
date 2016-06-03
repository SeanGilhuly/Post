//
//  Post.swift
//  Post
//
//  Created by Sean Gilhuly on 6/1/16.
//  Copyright © 2016 Sean Gilhuly. All rights reserved.

import Foundation

class Post {
    
    private let usernameKey = "username"
    private let textKey = "text"
    private let timestampKey = "timestamp"
    private let identifierKey = "identifier"
    
    let username: String
    let text: String
    let timestamp: NSTimeInterval
    let identifier: NSUUID
    
    var endpoint: NSURL? {
        return PostController.baseURL?.URLByAppendingPathComponent(self.identifier.UUIDString).URLByAppendingPathExtension("json")
    }
    
    var jsonValue: [String:AnyObject] {
        let json: [String:AnyObject] = [
            usernameKey: self.username,
            textKey: self.text,
            timestampKey: self.timestamp
        ]
        
        return json
    }
    
    var jsonData: NSData? {
        return try? NSJSONSerialization.dataWithJSONObject(self.jsonValue, options: NSJSONWritingOptions.PrettyPrinted)
    }
    
    init(username: String, text: String, timestamp: NSTimeInterval = NSDate().timeIntervalSince1970, identifier: NSUUID = NSUUID()) {
        self.username = username
        self.text = text
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    init?(dictionary: [String: AnyObject], identifier: String) {
        guard let username = dictionary [usernameKey] as? String,
            text = dictionary [textKey] as? String,
            timestamp = dictionary [timestampKey] as? NSTimeInterval,
            identifier = dictionary [identifierKey] as? NSUUID else {
                return nil
        }
        self.username = username
        self.text = text
        self.timestamp = timestamp
        self.identifier = identifier
    }
   
    
    
////    var queryTimestamp {
////        
////    }
}








