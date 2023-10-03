//
//  Item.swift
//  Todoey
//
//  Created by Daniel Felipe on 1/10/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
//Encodable, Decodable =
class Item: Codable {
    var title: String = ""
    var done: Bool = false
}
