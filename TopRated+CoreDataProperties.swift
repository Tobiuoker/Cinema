//
//  TopRated+CoreDataProperties.swift
//  
//
//  Created by Khaled on 11.06.2020.
//
//

import Foundation
import CoreData


extension TopRated {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TopRated> {
        return NSFetchRequest<TopRated>(entityName: "TopRated")
    }

    @NSManaged public var id: Int32
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Double
    @NSManaged public var posterPath: String?
    @NSManaged public var title: String?

}
