//
//  Note.swift
//  noteTaker
//
//  Created by Richardson, Eric on 3/16/16.
//  Copyright © 2016 Richardson, Eric. All rights reserved.
//

import Foundation
import CoreData


class Note: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var url: String


}
