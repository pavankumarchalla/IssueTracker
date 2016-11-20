//
//  Comment+CoreDataProperties.swift
//
//
//  Created by Pavan Kumar C on 15/11/16.
//
//

import Foundation
import CoreData


extension Comment {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
    return NSFetchRequest<Comment>(entityName: "Comment");
  }
  
  @NSManaged public var body: String?
  @NSManaged public var createdAt: NSDate?
  @NSManaged public var modifiedAt: NSDate?
  @NSManaged public var id: Int64
  @NSManaged public var userName: String?
  @NSManaged public var issue: Issue?
  
}
