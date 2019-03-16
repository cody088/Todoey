//
//  Category.swift
//  Todoey
//
//  Created by Cody on 2019/3/15.
//  Copyright © 2019 cody. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
