//
//  Item.swift
//  Todoey
//
//  Created by Daniel Felipe on 4/10/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    //Inverse table relationship indicating that parentaCategory belongs to category as item or child item
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
