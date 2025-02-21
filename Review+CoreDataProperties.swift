//
//  Review+CoreDataProperties.swift
//  prography-test
//
//  Created by 이명지 on 2/21/25.
//
//

import Foundation
import CoreData


extension ReviewEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReviewEntity> {
        return NSFetchRequest<ReviewEntity>(entityName: "ReviewEntity")
    }

    @NSManaged public var movieID: Int64
    @NSManaged public var movieTitle: String
    @NSManaged public var poster: String
    @NSManaged public var myRate: Int64
    @NSManaged public var overview: String
    @NSManaged public var comment: String?
    @NSManaged public var savedDate: Date
}

extension ReviewEntity : Identifiable {

}
