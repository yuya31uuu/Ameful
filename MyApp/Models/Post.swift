//
//  Post.swift
//  MyApp
//
//  Created by 武井優弥 on 2020/07/09.
//  Copyright © 2020 euyah.com. All rights reserved.
//

import UIKit

class Post: NSObject {

 var objectId: String
    var user: User
    var imageUrl: String
    var text: String
    var createDate: Date
    var isLiked: Bool?
//    var textView: String
    var likeCount: Int = 0
    
    //  ? があるやつは値が入ってなくても良い感じ
    
   var direction: String
    
    
    //毎回初期化
    init(objectId: String, user: User, imageUrl: String, text: String, createDate: Date, direction : String) {
        self.objectId = objectId
        self.user = user
        self.imageUrl = imageUrl
        self.text = text
        self.createDate = createDate
//        self.textView = textView
        
        
        
        
        
        self.direction = direction
        
    }
}


