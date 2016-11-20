//
//  Issue+CoreDataClass.swift
//  
//
//  Created by Pavan Kumar C on 15/11/16.
//
//

import Foundation
import CoreData
import SwiftyJSON

public class Issue: NSManagedObject {

  func buildFromDictionary(json: JSON) {
    self.title = json["title"].string
    self.body = json["body"].string
    self.number = Int64(json["number"].int32Value)
    self.id = Int64(json["id"].int32Value)
    self.createdAt = Utils.toDate(dateString: json["created_at"].string)
    self.modifiedAt = Utils.toDate(dateString: json["updated_at"].string)
    self.userName = json["user","login"].string
  }
  
}
