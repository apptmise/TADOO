//
//  Item.swift
//  TADOO
//
//  Created by Faiq Khan on 04/02/2019.
//  Copyright © 2019 apptmise. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
