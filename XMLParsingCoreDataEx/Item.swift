//
//  Item.swift
//  XMLParsingCoreDataEx
//
//  Created by EMG on 26/03/15.
//  Copyright (c) 2015 Karya. All rights reserved.
//

import Foundation
import CoreData

class Item: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var pubdate: String
    @NSManaged var descript: String
    @NSManaged var link: String
    @NSManaged var guid: String

}
