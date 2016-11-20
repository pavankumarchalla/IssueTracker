//
//  Comment+CoreDataClass.swift
//  
//
//  Created by Pavan Kumar C on 15/11/16.
//
//

import Foundation
import CoreData
import SwiftyJSON

public class Comment: NSManagedObject {

  func buildFromDictionary(json: JSON, issue: Issue) {
    
    self.body = json["body"].string
    self.createdAt = Utils.toDate(dateString: json["created_at"].string)
    self.modifiedAt = Utils.toDate(dateString: json["updated_at"].string)
    self.id = json["id"].int64Value
    self.userName = json["user","login"].string
    self.issue = issue
    issue.comments.insert(self)
  }
  
}
