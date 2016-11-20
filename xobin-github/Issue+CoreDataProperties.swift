//
//  Issue+CoreDataProperties.swift
//
//
//  Created by Pavan Kumar C on 15/11/16.
//
//

import Foundation
import CoreData


extension Issue {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Issue> {
    return NSFetchRequest<Issue>(entityName: "Issue");
  }
  
  @NSManaged public var number: Int64
  @NSManaged public var id: Int64
  @NSManaged public var title: String?
  @NSManaged public var body: String?
  @NSManaged public var userName: String?
  @NSManaged public var createdAt: NSDate?
  @NSManaged public var modifiedAt: NSDate?
  @NSManaged public var comments: Set<Comment>
}
