//
//  Word.swift
//  VocabBuilder
//
//  Created by Tomas Leriche on 6/21/18.
//  Copyright © 2018 Tomas Leriche. All rights reserved.
//

import Foundation
import RealmSwift

class Word: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var learned : Bool = false
    @objc dynamic var dateAdded : Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "words")
}
