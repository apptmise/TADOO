//
//  Category.swift
//  TADOO
//
//  Created by Faiq Khan on 04/02/2019.
//  Copyright © 2019 apptmise. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    let items = List<Item>() // -each item has a parent category
    // very similare to an array, eg:
    // let arrayName = Array<Int>()
}
