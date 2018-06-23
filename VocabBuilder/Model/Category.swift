//
//  Category.swift
//  VocabBuilder
//
//  Created by Tomas Leriche on 6/21/18.
//  Copyright © 2018 Tomas Leriche. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    @objc dynamic var name : String = ""
    @objc dynamic var learned : Bool = false
    
    let words = List<Word>()
}
