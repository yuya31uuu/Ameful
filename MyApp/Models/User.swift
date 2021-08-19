//
//  User.swift
//  MyApp
//
//  Created by 武井優弥 on 2020/07/09.
//  Copyright © 2020 euyah.com. All rights reserved.
//

import UIKit

class User: NSObject {

    var objectId: String
    var userName: String
    var displayName: String?
    var introduction: String?

    init(objectId: String, userName: String) {
        self.objectId = objectId
        self.userName = userName
    }
}
