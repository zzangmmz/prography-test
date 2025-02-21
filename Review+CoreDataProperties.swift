//
//  Review+CoreDataProperties.swift
//  prography-test
//
//  Created by 이명지 on 2/21/25.
//
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var movieID: Int64
    @NSManaged public var rate: Int64
    @NSManaged public var review: String?
    @NSManaged public var savedDate: Date

}

extension Review : Identifiable {

}
