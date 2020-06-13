//
//  Popular+CoreDataProperties.swift
//  
//
//  Created by Khaled on 11.06.2020.
//
//

import Foundation
import CoreData


extension Popular {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Popular> {
        return NSFetchRequest<Popular>(entityName: "Popular")
    }

    @NSManaged public var id: Int32
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Double
    @NSManaged public var posterPath: String?
    @NSManaged public var title: String?

}
