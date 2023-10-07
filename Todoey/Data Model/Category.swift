//
//  Category.swift
//  Todoey
//
//  Created by Daniel Felipe on 4/10/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    //List similar at array and help for relation data
    let items = List<Item>()
    // let array: Array<Int>()
    
}
